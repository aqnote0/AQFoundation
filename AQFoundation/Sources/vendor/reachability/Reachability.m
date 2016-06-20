
#import "Reachability.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

@interface Reachability ()

// 用来保存创建测试连接返回的引用
@property (nonatomic, assign) SCNetworkReachabilityRef  reachabilityRef;
@property (nonatomic,       ) dispatch_queue_t          reachabilitySerialQueue;
@property (nonatomic, strong) id                        reachabilityObject;

// 网络状态变更回调业务处理
-(void)reachabilityChanged:(SCNetworkReachabilityFlags)flags;

// 初始化方法
-(instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

@end


static NSString *reachabilityFlags(SCNetworkReachabilityFlags flags)  {
    return [NSString stringWithFormat:@"%c%c %c%c%c%c%c%c%c",
#if	TARGET_OS_IPHONE
            // 判断是否通过蜂窝网覆盖的连接，比如EDGE，GPRS或者目前的3G.主要是区别通过WiFi的连接
            (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
#else
            'X',
#endif
            // 能够连接网络
            (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
            // 能够连接网络，但是首先得建立连接过程
            (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
            (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
            (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
            (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
            (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
}

// 网络变更回调函数
// Start listening for reachability notifications on the current run loop
static void reachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
#pragma unused (target)

    Reachability *reachability = ((__bridge Reachability*)info);

    // We probably don't need an autoreleasepool here, as GCD docs state each queue has its own autorelease pool,
    // but what the heck eh?
    @autoreleasepool {
        [reachability reachabilityChanged:flags];
    }
}


@implementation Reachability

+(instancetype)reachabilityWithHostname:(NSString*)hostname {
    // 第一个参数可以为NULL或kCFAllocatorDefault，第二个参数为需要测试连接的IP地址
    // ref 用来保存创建测试连接返回的引用
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    return (ref ? [[self alloc] initWithReachabilityRef:ref] : nil);
}

+(instancetype)reachabilityWithAddress:(void *)hostAddress {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
    return (ref ? [[self alloc] initWithReachabilityRef:ref] : nil);
}

+(instancetype)reachabilityForInternetConnection {
    // 0.0.0.0时则可以查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len     = sizeof(zeroAddress);
    zeroAddress.sin_family  = AF_INET;
    
    return [self reachabilityWithAddress:&zeroAddress];
}

+(instancetype)reachabilityForLocalWiFi {
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len            = sizeof(localWifiAddress);
    localWifiAddress.sin_family         = AF_INET;
    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
    localWifiAddress.sin_addr.s_addr    = htonl(IN_LINKLOCALNETNUM);
    
    return [self reachabilityWithAddress:&localWifiAddress];
}


// Initialization methods
-(instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref {
    self = [super init];
    if (self != nil)  {
        self.reachableOnWWAN = YES;
        self.reachabilityRef = ref;
        // We need to create a serial queue.
        // We allocate this once for the lifetime of the notifier.
        self.reachabilitySerialQueue = dispatch_queue_create("com.aqnote.ios.reachability", NULL);
    }
    
    return self;    
}

-(void)dealloc {
    [self stopNotifier];

    if(self.reachabilityRef) {
        CFRelease(self.reachabilityRef);
        self.reachabilityRef = nil;
    }

	self.reachableBlock          = nil;
	self.unreachableBlock        = nil;
    self.reachabilitySerialQueue = nil;
}

#pragma mark - Notifier Methods

// Notifier 
// NOTE: This uses GCD to trigger the blocks - they *WILL NOT* be called on THE MAIN THREAD
// - In other words DO NOT DO ANY UI UPDATES IN THE BLOCKS.
//   INSTEAD USE dispatch_async(dispatch_get_main_queue(), ^{UISTUFF}) (or dispatch_sync if you want)

-(BOOL)startNotifier {
    // allow start notifier to be called multiple times
    if(self.reachabilityObject && (self.reachabilityObject == self))
        return YES;
    
    SCNetworkReachabilityContext context = { 0, NULL, NULL, NULL, NULL };
    context.info = (__bridge void *)self;

    if(SCNetworkReachabilitySetCallback(self.reachabilityRef, reachabilityCallback, &context)) {
        // Set it as our reachability queue, which will retain the queue
        if(SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, self.reachabilitySerialQueue)) {
            // this should do a retain on ourself, so as long as we're in notifier mode we shouldn't disappear out from under ourselves
            // woah
            self.reachabilityObject = self;
            return YES;
        } else {
#ifdef DEBUG
            NSLog(@"SCNetworkReachabilitySetDispatchQueue() failed: %s", SCErrorString(SCError()));
#endif
            // UH OH - FAILURE - stop any callbacks!
            SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
        }
    }
#ifdef DEBUG
    else {
        NSLog(@"SCNetworkReachabilitySetCallback() failed: %s", SCErrorString(SCError()));
    }
#endif
    
    // if we get here we fail at the internet
    self.reachabilityObject = nil;
    return NO;
}

-(void)stopNotifier {
    // First stop, any callbacks!
    SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
    
    // Unregister target from the GCD serial dispatch queue.
    SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, NULL);

    self.reachabilityObject = nil;
}

#pragma mark - reachability tests

// This is for the case where you flick the airplane mode;
// you end up getting something like this:
//Reachability: WR ct-----
//Reachability: -- -------
//Reachability: WR ct-----
//Reachability: -- -------
// We treat this as 4 UNREACHABLE triggers - really apple should do better than this

#define testcase (kSCNetworkReachabilityFlagsConnectionRequired | kSCNetworkReachabilityFlagsTransientConnection)

-(BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags {
    BOOL connectionUP = YES;
    
    if(!(flags & kSCNetworkReachabilityFlagsReachable))
        connectionUP = NO;
    
    if( (flags & testcase) == testcase )
        connectionUP = NO;
    
#if	TARGET_OS_IPHONE
    if(flags & kSCNetworkReachabilityFlagsIsWWAN) {
        // We're on 3G.
        if(!self.reachableOnWWAN) {
            // We don't want to connect when on 3G.
            connectionUP = NO;
        }
    }
#endif
    
    return connectionUP;
}

-(BOOL)isReachable {
    SCNetworkReachabilityFlags flags;
    if(!SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
        return NO;
    
    return [self isReachableWithFlags:flags];
}

-(BOOL)isReachableViaWWAN {
#if	TARGET_OS_IPHONE
    SCNetworkReachabilityFlags flags = 0;
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        // Check we're REACHABLE
        if(flags & kSCNetworkReachabilityFlagsReachable) {
            // Now, check we're on WWAN
            if(flags & kSCNetworkReachabilityFlagsIsWWAN) {
                return YES;
            }
        }
    }
#endif
    
    return NO;
}

-(BOOL)isReachableViaWiFi {
    SCNetworkReachabilityFlags flags = 0;
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        // Check we're reachable
        if((flags & kSCNetworkReachabilityFlagsReachable)) {
#if	TARGET_OS_IPHONE
            // Check we're NOT on WWAN
            if((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
                return NO;
            }
#endif
            return YES;
        }
    }
    
    return NO;
}

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired {
    SCNetworkReachabilityFlags flags;
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }
    return NO;
}

// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand {
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & (kSCNetworkReachabilityFlagsConnectionOnTraffic | kSCNetworkReachabilityFlagsConnectionOnDemand)));
	}
	return NO;
}

// Is user intervention required?
-(BOOL)isInterventionRequired {
    SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & kSCNetworkReachabilityFlagsInterventionRequired));
	}
	
	return NO;
}


#pragma mark - reachability status stuff

-(NetworkStatus)currentReachabilityStatus {
    if([self isReachable]) {
        if([self isReachableViaWiFi])
            return ReachableViaWiFi;
#if	TARGET_OS_IPHONE
        return ReachableViaWWAN;
#endif
    }
    return NotReachable;
}

// 保存返回的测试连接状态
-(SCNetworkReachabilityFlags)reachabilityFlags {
    SCNetworkReachabilityFlags flags = 0;
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        return flags;
    }
    return 0;
}

-(NSString*)currentReachabilityString {
	NetworkStatus temp = [self currentReachabilityStatus];
	if(temp == ReachableViaWWAN) {
        // Updated for the fact that we have CDMA phones now!
		return NSLocalizedString(@"Cellular", @"");
	}
	if (temp == ReachableViaWiFi) {
		return NSLocalizedString(@"WiFi", @"");
	}
	return NSLocalizedString(@"No Connection", @"");
}

-(NSString*)currentReachabilityFlags {
    return reachabilityFlags([self reachabilityFlags]);
}

#pragma mark - Callback function calls this method
// 调用业务注册的回调
-(void)reachabilityChanged:(SCNetworkReachabilityFlags)flags {
    if([self isReachableWithFlags:flags]) {
        if(self.reachableBlock) self.reachableBlock(self);
    } else {
        if(self.unreachableBlock) self.unreachableBlock(self);
    }
}

#pragma mark - Debug Description
- (NSString *) description {
    NSString *description = [NSString stringWithFormat:@"<%@: %#x (%@)>",
                             NSStringFromClass([self class]), (unsigned int) self, [self currentReachabilityFlags]];
    return description;
}

@end
