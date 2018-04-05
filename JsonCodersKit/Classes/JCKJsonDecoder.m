//
//  JCKJsonDecoder.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "JCKJsonDecoder.h"
#import "NSObject+DirectCoding.h"
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
    if (rawValue == nil) {
        return nil;
    }
    id result = nil;
    
    if ([rawValue isKindOfClass: aClass]) { // No decoding needed
        result = rawValue;
    } else if ([aClass jck_supportDirectDecodingFromJsonValue]) { // Decode simple classes (NSURL, NSUUID, ...)
        result = [aClass jck_decodeFromJsonValue: rawValue];
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
