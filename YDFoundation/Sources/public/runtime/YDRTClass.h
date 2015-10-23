
#import <Foundation/Foundation.h>

@class YDRTProtocol;
@class YDRTIvar;
@class YDRTMethod;
@class YDRTProperty;

/**
 * 运行时构建一个类
 */
@interface YDRTClass : NSObject {
  Class _class;
}

/**
 *  构建一个类名为name，父类为Nil的类
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype)unregisteredClassWithName:(NSString *)name;

/**
 *  构建一个类名为name，父类为superclass的类
 *
 *  @param name       <#name description#>
 *  @param superclass <#superclass description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype)unregisteredClassWithName:(NSString *)name
                           withSuperclass:(Class)superclass;

/**
 *  构建一个类名为name，父类为Nil的类
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithName:(NSString *)name;

/**
 *  构建一个类名为name，父类为superclass的类
 *
 *  @param name       <#name description#>
 *  @param superclass <#superclass description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithName:(NSString *)name withSuperclass:(Class)superclass;

/**
 *  对构建的类添加protocol协议
 *
 *  @param protocol <#protocol description#>
 */
- (void)addProtocol:(YDRTProtocol *)protocol;

/**
 *  对构建的类添加变量
 *
 *  @param ivar <#ivar description#>
 */
- (void)addIvar:(YDRTIvar *)ivar;

/**
 *  对构建的类添加方法
 *
 *  @param method <#method description#>
 */
- (void)addMethod:(YDRTMethod *)method;

/**
 *  对构建的类添加属性
 *
 *  @return <#return value description#>
 */
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
- (void)addProperty:(YDRTProperty *)property;
#endif

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (Class)registerClass;

@end
