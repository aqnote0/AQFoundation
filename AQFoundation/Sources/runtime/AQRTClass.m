
#import "AQRTClass.h"
#import "AQRTProtocol.h"
#import "AQRTIvar.h"
#import "AQRTMethod.h"
#import "AQRTProperty.h"

@implementation AQRTClass

+ (instancetype)unregisteredClassWithName:(NSString *)name {
  return [self unregisteredClassWithName:name withSuperclass:Nil];
}

+ (instancetype)unregisteredClassWithName:(NSString *)name
                           withSuperclass:(Class)superclass {
  return [[self alloc] initWithName:name withSuperclass:superclass];
}

- (instancetype)initWithName:(NSString *)name {
  return [self initWithName:name withSuperclass:Nil];
}

- (instancetype)initWithName:(NSString *)name withSuperclass:(Class)superclass {
  if ((self = [self init])) {
    // 运行时创建一个类
    _class = objc_allocateClassPair(superclass, [name UTF8String], 0);
    if (_class == nil) {
      return nil;
    }
  }
  return self;
}

- (void)addProtocol:(AQRTProtocol *)protocol {
  class_addProtocol(_class, [protocol objCProtocol]);
}

- (void)addIvar:(AQRTIvar *)ivar {
  const char *typeStr = [[ivar typeEncoding] UTF8String];
  NSUInteger size, alignment;
  NSGetSizeAndAlignment(typeStr, &size, &alignment);
  class_addIvar(_class, [[ivar name] UTF8String], size, log2(alignment),
                typeStr);
}

- (void)addMethod:(AQRTMethod *)method {
  class_addMethod(_class, [method selector], [method implementation],
                  [[method signature] UTF8String]);
}

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
- (void)addProperty:(RTProperty *)property {
  [property addToClass:_class];
}
#endif

- (Class)registerClass {
  objc_registerClassPair(_class);
  return _class;
}

@end
