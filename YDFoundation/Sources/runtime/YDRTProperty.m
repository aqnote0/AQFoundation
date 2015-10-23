
#import "YDRTProperty.h"

@interface YDRTObjCProperty : YDRTProperty {
  // 属性
  objc_property_t _property;
  // 所有属性参数
  NSMutableDictionary /*objc_property_attribute_t*/ *_attrs;
  // 属性名
  NSString *_name;
}
@end

@implementation YDRTObjCProperty

- (instancetype)initWithObjCProperty:(objc_property_t)property {
  if ((self = [self init])) {
    _property = property;
    NSArray *attrPairs =
        [[NSString stringWithUTF8String:property_getAttributes(property)]
            componentsSeparatedByString:@","];
    _attrs = [[NSMutableDictionary alloc] initWithCapacity:[attrPairs count]];
    for (NSString *attrPair in attrPairs)
      // attrPair第一个字符代表属性值类型名，不是所有的类型名都有对应的值
      [_attrs setObject:[attrPair substringFromIndex:1]
                 forKey:[attrPair substringToIndex:1]];
  }
  return self;
}

- (instancetype)initWithName:(NSString *)name
                  attributes:(NSDictionary *)attributes {
  if ((self = [self init])) {
    _name = [name copy];
    _attrs = [attributes copy];
  }
  return self;
}

- (NSString *)name {
  if (_property)
    return [NSString stringWithUTF8String:property_getName(_property)];
  else
    return _name;
}

- (NSDictionary *)attributes {
  return [_attrs copy];
}

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
- (BOOL)addToClass:(Class)classToAddTo {
  NSDictionary *attrs = [self attributes];
  objc_property_attribute_t *cattrs = (objc_property_attribute_t *)calloc(
      [attrs count], sizeof(objc_property_attribute_t));
  unsigned attrIdx = 0;
  for (NSString *attrCode in attrs) {
    // 属性参数类型名
    cattrs[attrIdx].name = [attrCode UTF8String];
    // 属性参数类型值，不是所有的类型名都有对应的值
    cattrs[attrIdx].value = [[attrs objectForKey:attrCode] UTF8String];
    attrIdx++;
  }
  BOOL result = class_addProperty(classToAddTo, [[self name] UTF8String],
                                  cattrs, [attrs count]);
  free(cattrs);
  return result;
}
#endif

- (NSString *)attributeEncodings {
  NSMutableArray *filteredAttributes =
      [NSMutableArray arrayWithCapacity:[_attrs count] - 2];
  for (NSString *attrKey in _attrs) {
    if (![attrKey isEqualToString:kYDRTPropertyTypeEncodingAttribute] &&
        ![attrKey isEqualToString:kYDRTPropertyBackingIVarNameAttribute])
      [filteredAttributes addObject:[_attrs objectForKey:attrKey]];
  }
  return [filteredAttributes componentsJoinedByString:@","];
}

- (BOOL)hasAttribute:(NSString *)code {
  return [_attrs objectForKey:code] != nil;
}

- (BOOL)isReadOnly {
  return [self hasAttribute:kYDRTPropertyReadOnlyAttribute];
}

- (YDRTPropertySetterSemantics)setterSemantics {
  if ([self hasAttribute:kYDRTPropertyCopyAttribute])
    return YDRTPropertySetterSemanticsCopy;
  if ([self hasAttribute:kYDRTPropertyRetainAttribute])
    return YDRTPropertySetterSemanticsRetain;
  return YDRTPropertySetterSemanticsAssign;
}

- (BOOL)isNonAtomic {
  return [self hasAttribute:kYDRTPropertyNonAtomicAttribute];
}

- (BOOL)isDynamic {
  return [self hasAttribute:kYDRTPropertyDynamicAttribute];
}

- (BOOL)isWeakReference {
  return [self hasAttribute:kYDRTPropertyWeakReferenceAttribute];
}

- (BOOL)isEligibleForGarbageCollection {
  return
      [self hasAttribute:kYDRTPropertyEligibleForGarbageCollectionAttribute];
}

- (NSString *)contentOfAttribute:(NSString *)code {
  return [_attrs objectForKey:code];
}

- (SEL)customGetter {
  return NSSelectorFromString(
      [self contentOfAttribute:kYDRTPropertyCustomGetterAttribute]);
}

- (SEL)customSetter {
  return NSSelectorFromString(
      [self contentOfAttribute:kYDRTPropertyCustomSetterAttribute]);
}

- (NSString *)typeEncoding {
  return [self contentOfAttribute:kYDRTPropertyTypeEncodingAttribute];
}

- (NSString *)oldTypeEncoding {
  return [self contentOfAttribute:kYDRTPropertyOldTypeEncodingAttribute];
}

- (NSString *)ivarName {
  return [self contentOfAttribute:kYDRTPropertyBackingIVarNameAttribute];
}

@end

@implementation YDRTProperty

+ (instancetype)propertyWithObjCProperty:(objc_property_t)property {
  return [[self alloc] initWithObjCProperty:property];
}

+ (instancetype)propertyWithName:(NSString *)name
                      attributes:(NSDictionary *)attributes {
  return [[self alloc] initWithName:name attributes:attributes];
}

- (instancetype)initWithObjCProperty:(objc_property_t)property {
  return [[YDRTObjCProperty alloc] initWithObjCProperty:property];
}

- (instancetype)initWithName:(NSString *)name
                  attributes:(NSDictionary *)attributes {
  return [[YDRTObjCProperty alloc] initWithName:name attributes:attributes];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ %p: %@ %@ %@ %@>", [self class], self,
                                    [self name], [self attributeEncodings],
                                    [self typeEncoding], [self ivarName]];
}

- (BOOL)isEqual:(id)other {
  return [other isKindOfClass:[YDRTProperty class]] &&
         [[self name] isEqual:[other name]] &&
         ([self attributeEncodings]
              ? [[self attributeEncodings] isEqual:[other attributeEncodings]]
              : ![other attributeEncodings]) &&
         [[self typeEncoding] isEqual:[other typeEncoding]] &&
         ([self ivarName] ? [[self ivarName] isEqual:[other ivarName]]
                          : ![other ivarName]);
}

- (NSUInteger)hash {
  return [[self name] hash] ^ [[self typeEncoding] hash];
}

- (NSString *)name {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

// 属性值列表：属性值类型名－>属性值类型值
- (NSDictionary *)attributes {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

// 将属性添加到对应类中
- (BOOL)addToClass:(Class)classToAddTo {
  [self doesNotRecognizeSelector:_cmd];
  return NO;
}

// 返回过滤掉
- (NSString *)attributeEncodings {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

// 返回属性是否只读
- (BOOL)isReadOnly {
  [self doesNotRecognizeSelector:_cmd];
  return NO;
}

// 返回赋值方式
- (YDRTPropertySetterSemantics)setterSemantics {
  [self doesNotRecognizeSelector:_cmd];
  return YDRTPropertySetterSemanticsAssign;
}

- (BOOL)isNonAtomic {
  [self doesNotRecognizeSelector:_cmd];
  return NO;
}

- (BOOL)isDynamic {
  [self doesNotRecognizeSelector:_cmd];
  return NO;
}

- (BOOL)isWeakReference {
  [self doesNotRecognizeSelector:_cmd];
  return NO;
}

- (BOOL)isEligibleForGarbageCollection {
  [self doesNotRecognizeSelector:_cmd];
  return NO;
}

- (SEL)customGetter {
  [self doesNotRecognizeSelector:_cmd];
  return (SEL)0;
}

- (SEL)customSetter {
  [self doesNotRecognizeSelector:_cmd];
  return (SEL)0;
}

- (NSString *)typeEncoding {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (NSString *)oldTypeEncoding {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (NSString *)ivarName {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

@end

NSString *const kYDRTPropertyTypeEncodingAttribute = @"T";
NSString *const kYDRTPropertyBackingIVarNameAttribute = @"V";
NSString *const kYDRTPropertyCopyAttribute = @"C";
NSString *const kYDRTPropertyCustomGetterAttribute = @"G";
NSString *const kYDRTPropertyCustomSetterAttribute = @"S";
NSString *const kYDRTPropertyDynamicAttribute = @"D";
NSString *const kYDRTPropertyEligibleForGarbageCollectionAttribute = @"P";
NSString *const kYDRTPropertyNonAtomicAttribute = @"N";
NSString *const kYDRTPropertyOldTypeEncodingAttribute = @"t";
NSString *const kYDRTPropertyReadOnlyAttribute = @"R";
NSString *const kYDRTPropertyRetainAttribute = @"&";
NSString *const kYDRTPropertyWeakReferenceAttribute = @"W";