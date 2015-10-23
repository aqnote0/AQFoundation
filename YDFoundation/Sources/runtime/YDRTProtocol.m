
#import <objc/runtime.h>
#import "YDRTProtocol.h"
#import "YDRTMethod.h"

@interface YDRTObjCProtocol : YDRTProtocol {
  Protocol *_protocol;
}
@end

@implementation YDRTObjCProtocol

- (id)initWithObjCProtocol:(Protocol *)protocol {
  if ((self = [self init])) {
    _protocol = protocol;
  }
  return self;
}

- (Protocol *)objCProtocol {
  return _protocol;
}

@end

@implementation YDRTProtocol

+ (NSArray *)allProtocols {
  unsigned int count;
  Protocol *__unsafe_unretained *protocols = objc_copyProtocolList(&count);

  NSMutableArray *array = [NSMutableArray array];
  for (unsigned i = 0; i < count; i++)
    [array addObject:[[self alloc] initWithObjCProtocol:protocols[i]]];

  free(protocols);
  return array;
}

+ (id)protocolWithObjCProtocol:(Protocol *)protocol {
  return [[self alloc] initWithObjCProtocol:protocol];
}

+ (id)protocolWithName:(NSString *)name {
  return [[self alloc] initWithName:name];
}

- (id)initWithObjCProtocol:(Protocol *)protocol {
  return [[YDRTObjCProtocol alloc] initWithObjCProtocol:protocol];
}

- (id)initWithName:(NSString *)name {
  return
      [self initWithObjCProtocol:
                objc_getProtocol([name
                    cStringUsingEncoding:[NSString defaultCStringEncoding]])];
}

- (NSString *)description {
  return [NSString
      stringWithFormat:@"<%@ %p: %@>", [self class], self, [self name]];
}

- (BOOL)isEqual:(id)other {
  return [other isKindOfClass:[YDRTProtocol class]] &&
         protocol_isEqual([self objCProtocol], [other objCProtocol]);
}

- (Protocol *)objCProtocol {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (NSString *)name {
  return [NSString stringWithUTF8String:protocol_getName([self objCProtocol])];
}

- (NSArray *)incorporatedProtocols {
  unsigned int count;
  Protocol *__unsafe_unretained *protocols =
      protocol_copyProtocolList([self objCProtocol], &count);

  NSMutableArray *array = [NSMutableArray array];
  for (unsigned i = 0; i < count; i++)
    [array addObject:[YDRTProtocol protocolWithObjCProtocol:protocols[i]]];

  free(protocols);
  return array;
}

- (NSArray *)methodsRequired:(BOOL)isRequiredMethod
                    instance:(BOOL)isInstanceMethod {
  unsigned int count;
  struct objc_method_description *methods = protocol_copyMethodDescriptionList(
      [self objCProtocol], isRequiredMethod, isInstanceMethod, &count);

  NSMutableArray *array = [NSMutableArray array];
  for (unsigned i = 0; i < count; i++) {
    NSString *signature =
        [NSString stringWithCString:methods[i].types
                           encoding:[NSString defaultCStringEncoding]];
    [array addObject:[YDRTMethod methodWithSelector:methods[i].name
                                                  imp:NULL
                                                 sign:signature]];
  }

  free(methods);
  return array;
}

@end
