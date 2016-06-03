

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 * 方法封装类
 */
@interface AQRTMethod : NSObject

// 用Method实例构造方法一个AQRTMethod实例
+ (id)methodWithObjCMethod:(Method)method;

// 用方法名描述、方法地址、方法签名 构造方法一个AQRTMethod实例
+ (id)methodWithSelector:(SEL)sel imp:(IMP)imp sign:(NSString *)sign;

// 用Method实例构造方法一个AQRTMethod实例
- (id)initWithObjCMethod:(Method)method;

// 用方法名描述、方法地址、方法签名 构造方法一个AQRTMethod实例
- (id)initWithSelector:(SEL)sel imp:(IMP)imp sign:(NSString *)sign;

// 返回方法描述
- (SEL)selector;

// 返回方法描述名
- (NSString *)selectorName;

// 返回方法地址
- (IMP)implementation;

// 返回签名
- (NSString *)signature;

// for ObjC method instances, sets the underlying implementation
// for selector/implementation/signature instances, just changes the pointer
- (void)setImp:(IMP)newImp;

// easy sending of arbitrary methods with arbitrary arguments
// a simpler alternative to NSInvocation etc.
// for simple cases where the return type is an id, use sendToTarget:
// for others, use the returnValue:variant and pass a pointer to storage
// (you can pass NULL if you don't care about the return value)
// all arguments MUST BE WRAPPED in RTARG, e.g.:
// [method sendToTarget:target, RTARG(arg1), RTARG(arg2)]
#define RT_ARG_MAGIC_COOKIE 0xdeadbeef
#define RTARG(expr) \
  RT_ARG_MAGIC_COOKIE, @encode(__typeof__(expr)), (__typeof__(expr)[]) { expr }
// 指定参数内容，调用target实例的对应方法，并返回调用结果
// 调用方法 [method sendToTarget:target, RTARG(arg1), RTARG(arg2)]
- (id)sendToTarget:(id)target, ...;

// 指定args参数，调用target实例的对应方法，并通过rePtr返回调用结果
- (void)returnValue:(void *)retPtr sendToTarget:(id)target args:(va_list)args;

@end
