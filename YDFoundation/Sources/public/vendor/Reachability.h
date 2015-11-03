
#import <Foundation/Foundation.h>
// SystemConfiguration框架里有提供了和联网相关的函数，可以用来检查网络的连接状态
#import <SystemConfiguration/SystemConfiguration.h>


/** 
 * Create NS_ENUM macro if it does not exist on the targeted version of iOS or OS X.
 *
 * @see http://nshipster.com/ns_enum-ns_options/
 **/
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

// 定义网络状态
typedef NS_ENUM(NSInteger, NetworkStatus) {
    NotReachable = 0,
    ReachableViaWiFi = 2,
    ReachableViaWWAN = 1
};

@class Reachability;

// 网络可达业务回调
typedef void (^NetworkReachable)(Reachability * reachability);
// 网络不可达业务回调
typedef void (^NetworkUnreachable)(Reachability * reachability);

@interface Reachability : NSObject

@property (nonatomic, copy) NetworkReachable    reachableBlock;
@property (nonatomic, copy) NetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;

// 用于检查网络请求是否可到达指定的主机名
+(instancetype)reachabilityWithHostname:(NSString*)hostname;

// 用于检查网络请求是否可到达指定的IP地址
+(instancetype)reachabilityWithAddress:(void *)hostAddress;

// 用于检查路由连接是否有效
+(instancetype)reachabilityForInternetConnection;

// 用于检查本地的WiFi连接是否有效
+(instancetype)reachabilityForLocalWiFi;

// 开始网络状态监听
-(BOOL)startNotifier;

// 结束网络状态监听
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
// Identical DDG variant.
-(BOOL)isConnectionRequired;

// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;

// Is user intervention required?
-(BOOL)isInterventionRequired;

// 当前网络请求可到达状态
-(NetworkStatus)currentReachabilityStatus;

-(NSString*)currentReachabilityString;

-(NSString*)currentReachabilityFlags;

// 返回系统网络标示
-(SCNetworkReachabilityFlags)reachabilityFlags;

@end
