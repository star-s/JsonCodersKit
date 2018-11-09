//
//  JCKJsonDecoder.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "JCKJsonDecoder.h"
#import "CollectionMapping.h"
#import "NSNull+NumericExtension.h"

static BOOL nullIsTheValue = NO;

@implementation JCKJsonDecoder

+ (void)setDecodeNullAsValue:(BOOL)nullValue
{
    nullIsTheValue = nullValue;
}

- (instancetype)initWithJSONObject:(NSDictionary *)obj
{
    NSParameterAssert([obj isKindOfClass: [NSDictionary class]]);
    self = [super init];
    if (self) {
        _JSONObject = obj;
    }
    return self;
}

- (BOOL)allowsKeyedCoding
{
    return YES;
}

- (BOOL)containsValueForKey:(NSString *)key
{
    if (nullIsTheValue) {
        return [self.JSONObject.allKeys containsObject: key];
    } else {
        return [self decodeObjectForKey: key] != nil;
    }
}

- (id)decodeObjectForKey:(NSString *)key
{
    if (nullIsTheValue) {
        return [self.JSONObject objectForKey: key];
    } else {
        id value = [self.JSONObject objectForKey: key];
        return [value isEqual: [NSNull null]] ? nil : value;
    }
}

- (BOOL)decodeBoolForKey:(NSString *)key
{
    return [[self decodeObjectForKey: key] boolValue];
}

- (int)decodeIntForKey:(NSString *)key
{
    return [[self decodeObjectForKey: key] intValue];
}

- (float)decodeFloatForKey:(NSString *)key
{
    return [[self decodeObjectForKey: key] floatValue];
}

- (double)decodeDoubleForKey:(NSString *)key
{
    return [[self decodeObjectForKey: key] doubleValue];
}

- (NSInteger)decodeIntegerForKey:(NSString *)key
{
    return [[self decodeObjectForKey: key] integerValue];
}

- (int32_t)decodeInt32ForKey:(NSString *)key
{
    return [self decodeIntForKey: key];
}

- (int64_t)decodeInt64ForKey:(NSString *)key
{
    return [[self decodeObjectForKey: key] longLongValue];
}

- (id)decodeObjectOfClass:(Class)aClass forKey:(NSString *)key
{
    return [self convertRawValue: self.JSONObject[key] toObjectOfClass: aClass];
}

- (id)decodeTopLevelObjectOfClass:(Class)aClass
{
    id decodedObject = [[aClass alloc] initWithCoder: self];
    return [decodedObject awakeAfterUsingCoder: self];
}

- (NSArray *)decodeArrayObjectsOfClass:(Class)aClass forKey:(NSString *)key
{
    NSArray *result = nil;
    
    id rawValue = self.JSONObject[key];
    
    if ([rawValue isKindOfClass: [NSArray class]]) {
        result = [rawValue mapWithBlock: ^(id anObject){
            return [self convertRawValue: anObject toObjectOfClass: aClass];
        }];
    }
    return result;
}

- (id)convertRawValue:(id)rawValue toObjectOfClass:(Class)aClass
{
    if (!rawValue || [rawValue isKindOfClass: aClass]) { // No decoding needed ???
        return rawValue;
    }
    id result = nil;
    
    NSValueTransformer *helper = [self.class transformerForClass: aClass];
    
    if (helper) { // Decode simple classes (NSURL, NSUUID, ...)
        result = [helper transformedValue: rawValue];
    } else if ([aClass conformsToProtocol: @protocol(NSCoding)] && [rawValue isKindOfClass: [NSDictionary class]]) { // Decode complex classes
        JCKJsonDecoder *decoder = [[self.class alloc] initWithJSONObject: rawValue];
        result = [decoder decodeTopLevelObjectOfClass: aClass];
#if DEBUG
    } else {
        NSLog(@"%@ - Can't convert value: %@ to class: %@", self, rawValue, NSStringFromClass(aClass));
#endif
    }
    return result;
}

@end

#import <objc/runtime.h>
#import "JCKDirectCodingHelpers.h"

@implementation JCKJsonDecoder (Transformers)

+ (NSMapTable *)transformersMap
{
    @synchronized (self) {
        NSMapTable *result = objc_getAssociatedObject(self, _cmd);
        if (!result) {
            result = [NSMapTable strongToStrongObjectsMapTable];
            objc_setAssociatedObject(self, _cmd, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return result;
    }
}

+ (void)setTransformer:(id)obj forClass:(Class)aClass
{
    NSString *key = NSStringFromClass(aClass);
    NSMapTable *map = self.transformersMap;
    if (obj) {
        NSAssert([obj isKindOfClass: [NSString class]] || [obj isKindOfClass: [NSValueTransformer class]], @"%@ is not NSString or NSValueTransformer", obj);
        [map setObject: obj forKey: key];
    } else {
        [map removeObjectForKey: key];
    }
}

+ (nullable NSValueTransformer *)transformerForClass:(Class)aClass
{
    NSString *key = NSStringFromClass(aClass);
    NSValueTransformer *result = [self.transformersMap objectForKey: key];
    if (!result) {
        static NSDictionary *defaultTransformers = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            defaultTransformers = @{
                                    @"NSString"     : JCKStringFromJsonTransformerName,
                                    @"NSNull"       : JCKNullFromJsonTransformerName,
                                    @"NSNumber"     : JCKNumberFromJsonTransformerName,
                                    @"NSDictionary" : JCKDictionaryFromJsonTransformerName,
                                    @"NSArray"      : JCKArrayFromJsonTransformerName,
                                    @"NSURL"        : JCKURLFromJsonTransformerName,
                                    @"NSUUID"       : JCKUUIDFromJsonTransformerName,
                                    @"NSDate"       : JCKDateFromJsonTransformerName,
                                    @"NSData"       : JCKDataFromJsonTransformerName,
                                    @"UIColor"      : JCKColorFromJsonTransformerName,
                                    @"NSColor"      : JCKColorFromJsonTransformerName
                                    };
        });
        result = defaultTransformers[key];
    }
    return [result isKindOfClass: [NSString class]] ? [NSValueTransformer valueTransformerForName: result] : result;
}

@end
