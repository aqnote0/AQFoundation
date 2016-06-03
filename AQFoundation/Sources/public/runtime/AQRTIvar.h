
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

/**
 * 变量封装类
 */
@interface AQRTIvar : NSObject

// 用Ivar实例构造方法一个AQRTIvar实例
+ (instancetype)ivarWithObjCIvar:(Ivar)ivar;

// 用name和typeEncoding构造方法一个AQRTIvar实例
+ (instancetype)ivarWithName:(NSString *)name
                typeEncoding:(NSString *)typeEncoding;

// 用name和(char *)encode构造方法一个AQRTIvar实例
+ (instancetype)ivarWithName:(NSString *)name encode:(const char *)encode;

// 用Ivar实例构造方法一个AQRTIvar实例
- (instancetype)initWithObjCIvar:(Ivar)ivar;

// 用name和typeEncoding构造方法一个AQRTIvar实例
- (instancetype)initWithName:(NSString *)name
                typeEncoding:(NSString *)typeEncoding;

// 返回变了的名称
- (NSString *)name;

// 返回变量的类型
- (NSString *)typeEncoding;

// 获取变量的占用空间
- (ptrdiff_t)offset;

@end
