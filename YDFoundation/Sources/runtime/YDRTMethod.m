
#import <stdarg.h>
#import "YDRTMethod.h"

/**
 * 通过Method 变量构造的子类
 */
@interface YDRTObjCMethod : YDRTMethod {
  Method _m;
}

@end

@implementation YDRTObjCMethod

- (id)initWithObjCMethod:(Method)method {
  if ((self = [self init])) {
    _m = method;
  }
  return self;
}

- (SEL)selector {
  return method_getName(_m);
}

- (IMP)implementation {
  return method_getImplementation(_m);
}

- (NSString *)signature {
  return [NSString stringWithUTF8String:method_getTypeEncoding(_m)];
}

- (void)setImp:(IMP)newImp {
  method_setImplementation(_m, newImp);
}

@end

/**
 * 通过方法属性、方法地址、方法签名 变量构造的子类
 */
@interface YDRTComponentsMethod : YDRTMethod {
  SEL _sel;
  IMP _imp;
  NSString *_sig;
}

@end

@implementation YDRTComponentsMethod

- (id)initWithSelector:(SEL)sel imp:(IMP)imp sign:(NSString *)sign {
  if ((self = [self init])) {
    _sel = sel;
    _imp = imp;
    _sig = [sign copy];
  }
  return self;
}

- (SEL)selector {
  return _sel;
}

- (IMP)implementation {
  return _imp;
}

- (NSString *)signature {
  return _sig;
}

- (void)setImp:(IMP)newImp {
  _imp = newImp;
}

@end

@implementation YDRTMethod

+ (id)methodWithObjCMethod:(Method)method {
  return [[self alloc] initWithObjCMethod:method];
}

+ (id)methodWithSelector:(SEL)sel imp:(IMP)imp sign:(NSString *)sign {
  return [[self alloc] initWithSelector:sel imp:imp sign:sign];
}

- (id)initWithObjCMethod:(Method)method {
  return [[YDRTObjCMethod alloc] initWithObjCMethod:method];
}

- (id)initWithSelector:(SEL)sel imp:(IMP)imp sign:(NSString *)sign {
  return
      [[YDRTComponentsMethod alloc] initWithSelector:sel imp:imp sign:sign];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ %p:%@ %p %@>", [self class], self,
                                    NSStringFromSelector([self selector]),
                                    [self implementation], [self signature]];
}

- (BOOL)isEqual:(id)other {
  return [other isKindOfClass:[YDRTMethod class]] &&
         [self selector] == [other selector] &&
         [self implementation] == [other implementation] &&
         [[self signature] isEqual:[other signature]];
}

- (NSUInteger)hash {
  return (NSUInteger)(void *)[self selector] ^
         (NSUInteger)[self implementation] ^ [[self signature] hash];
}

- (SEL)selector {
  [self doesNotRecognizeSelector:_cmd];
  return NULL;
}

- (NSString *)selectorName {
  return NSStringFromSelector([self selector]);
}

- (IMP)implementation {
  [self doesNotRecognizeSelector:_cmd];
  return NULL;
}

- (NSString *)signature {
  [self doesNotRecognizeSelector:_cmd];
  return NULL;
}

- (void)setImp:(IMP)newImp {
  [self doesNotRecognizeSelector:_cmd];
}

- (void)returnValue:(void *)retPtr sendToTarget:(id)target args:(va_list)args {
  NSMethodSignature *signature =
      [target methodSignatureForSelector:[self selector]];
  NSInvocation *invocation =
      [NSInvocation invocationWithMethodSignature:signature];
  NSUInteger argumentCount = [signature numberOfArguments];
  //  设置调用实例
  [invocation setTarget:target];
  // 设置方法描述
  [invocation setSelector:[self selector]];
  // 因为方法调用有self（调用对象）和_cmd（选择器）这2个隐含参数，
  // 因此设置参数时，索引应该从2开始
  for (NSUInteger i = 2; i < argumentCount; i++) {
    int cookie = va_arg(args, int);
    if (cookie != RT_ARG_MAGIC_COOKIE) {
      NSLog(@"%s:incorrect magic cookie %08x; see RTARG()", __func__, cookie);
      abort();
    }
    const char *typeStr = va_arg(args, char *);
    void *argPtr = va_arg(args, void *);

    NSUInteger inSize;
    NSGetSizeAndAlignment(typeStr, &inSize, NULL);
    NSUInteger sigSize;
    NSGetSizeAndAlignment([signature getArgumentTypeAtIndex:i], &sigSize, NULL);
    // 比对参数占用内存空间大小是否相等
    if (inSize != sigSize) {
      NSLog(@"%s:size mismatch argument; in type:%s (%lu) requested:%s (%lu)",
            __func__, typeStr, (long)inSize,
            [signature getArgumentTypeAtIndex:i], (long)sigSize);
      abort();
    }
    // 设置方法参数
    [invocation setArgument:argPtr atIndex:i];
  }
  // 调用方法
  [invocation invoke];

  // 判断是否有返回，0代表无返回；有返回赋值给void *指针
  if ([signature methodReturnLength] && retPtr)
    [invocation getReturnValue:retPtr];
}

- (id)sendToTarget:(id)target, ... {
  NSParameterAssert(
      [[self signature] hasPrefix:[NSString stringWithUTF8String:@encode(id)]]);

  id retVal = nil;

  va_list args;
  va_start(args, target);
  [self returnValue:&retVal sendToTarget:target args:args];
  va_end(args);

  return retVal;
}

@end
