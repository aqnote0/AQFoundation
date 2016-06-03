
#import "AQRTProperty.h"

@interface AQRTObjCProperty : AQRTProperty {
  // 属性
  objc_property_t _property;
  // 所有属性参数
  NSMutableDictionary /*objc_property_attribute_t*/ *_attrs;
  // 属性名
  NSString *_name;
}
@end

@implementation AQRTObjCProperty

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
    if (![attrKey isEqualToString:kAQRTPropertyTypeEncodingAttribute] &&
        ![attrKey isEqualToString:kAQRTPropertyBackingIVarNameAttribute])
      [filteredAttributes addObject:[_attrs objectForKey:attrKey]];
  }
  return [filteredAttributes componentsJoinedByString:@","];
}

- (BOOL)hasAttribute:(NSString *)code {
  return [_attrs objectForKey:code] != nil;
}

- (BOOL)isReadOnly {
  return [self hasAttribute:kAQRTPropertyReadOnlyAttribute];
}

- (AQRTPropertySetterSemantics)setterSemantics {
  if ([self hasAttribute:kAQRTPropertyCopyAttribute])
    return AQRTPropertySetterSemanticsCopy;
  if ([self hasAttribute:kAQRTPropertyRetainAttribute])
    return AQRTPropertySetterSemanticsRetain;
  return AQRTPropertySetterSemanticsAssign;
}

- (BOOL)isNonAtomic {
  return [self hasAttribute:kAQRTPropertyNonAtomicAttribute];
}

- (BOOL)isDynamic {
  return [self hasAttribute:kAQRTPropertAQynamicAttribute];
}

- (BOOL)isWeakReference {
  return [self hasAttribute:kAQRTPropertyWeakReferenceAttribute];
}

- (BOOL)isEligibleForGarbageCollection {
  return
      [self hasAttribute:kAQRTPropertyEligibleForGarbageCollectionAttribute];
}

- (NSString *)contentOfAttribute:(NSString *)code {
  return [_attrs objectForKey:code];
}

- (SEL)customGetter {
  return NSSelectorFromString(
      [self contentOfAttribute:kAQRTPropertyCustomGetterAttribute]);
}

- (SEL)customSetter {
  return NSSelectorFromString(
      [self contentOfAttribute:kAQRTPropertyCustomSetterAttribute]);
}

- (NSString *)typeEncoding {
  return [self contentOfAttribute:kAQRTPropertyTypeEncodingAttribute];
}

- (NSString *)oldTypeEncoding {
  return [self contentOfAttribute:kAQRTPropertyOldTypeEncodingAttribute];
}

- (NSString *)ivarName {
  return [self contentOfAttribute:kAQRTPropertyBackingIVarNameAttribute];
}

@end

@implementation AQRTProperty

+ (instancetype)propertyWithObjCProperty:(objc_property_t)property {
  return [[self alloc] initWithObjCProperty:property];
}

+ (instancetype)propertyWithName:(NSString *)name
                      attributes:(NSDictionary *)attributes {
  return [[self alloc] initWithName:name attributes:attributes];
}

- (instancetype)initWithObjCProperty:(objc_property_t)property {
  return [[AQRTObjCProperty alloc] initWithObjCProperty:property];
}

- (instancetype)initWithName:(NSString *)name
                  attributes:(NSDictionary *)attributes {
  return [[AQRTObjCProperty alloc] initWithName:name attributes:attributes];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ %p: %@ %@ %@ %@>", [self class], self,
                                    [self name], [self attributeEncodings],
                                    [self typeEncoding], [self ivarName]];
}

- (BOOL)isEqual:(id)other {
  return [other isKindOfClass:[AQRTProperty class]] &&
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
- (AQRTPropertySetterSemantics)setterSemantics {
  [self doesNotRecognizeSelector:_cmd];
  return AQRTPropertySetterSemanticsAssign;
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

NSString *const kAQRTPropertyTypeEncodingAttribute = @"T";
NSString *const kAQRTPropertyBackingIVarNameAttribute = @"V";
NSString *const kAQRTPropertyCopyAttribute = @"C";
NSString *const kAQRTPropertyCustomGetterAttribute = @"G";
NSString *const kAQRTPropertyCustomSetterAttribute = @"S";
NSString *const kAQRTPropertAQynamicAttribute = @"D";
NSString *const kAQRTPropertyEligibleForGarbageCollectionAttribute = @"P";
NSString *const kAQRTPropertyNonAtomicAttribute = @"N";
NSString *const kAQRTPropertyOldTypeEncodingAttribute = @"t";
NSString *const kAQRTPropertyReadOnlyAttribute = @"R";
NSString *const kAQRTPropertyRetainAttribute = @"&";
NSString *const kAQRTPropertyWeakReferenceAttribute = @"W";