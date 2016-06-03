
#import <Foundation/Foundation.h>

@interface AQRTProtocol : NSObject

/**
 * 返回runtime的所有协议，封装的对象为AQRTProtocol
 */
+ (NSArray /**AQRTProtocol*/ *)allProtocols;

/**
 * 用标准协议生成一个AQRTProtocol实例
 */
+ (id)protocolWithObjCProtocol:(Protocol *)protocol;

/**
 * 通过协议名称构造并返回一个AQRTProtocol实例
 */
+ (id)protocolWithName:(NSString *)name;

/**
 * 用标准协议生成一个AQRTProtocol实例
 */
- (id)initWithObjCProtocol:(Protocol *)protocol;

/**
 * 通过协议名称构造并返回一个AQRTProtocol实例
 */
- (id)initWithName:(NSString *)name;

/**
 * 返回协议本身
 */
- (Protocol *)objCProtocol;

/**
 * 返回协议名称
 */
- (NSString *)name;

/**
 * 返回协议本身继承的协议列表
 */
- (NSArray /*AQRTProtocol*/ *)incorporatedProtocols;

/**
 * 返回协议对应的空实现列表
 * isRequiredMethod 协议中的方法是否有@required
 * isInstanceMethod 协议中的方法是否是实例方法
 */
- (NSArray /*AQRTMethod*/ *)methodsRequired:(BOOL)isRequiredMethod
                                     instance:(BOOL)isInstanceMethod;

@end
