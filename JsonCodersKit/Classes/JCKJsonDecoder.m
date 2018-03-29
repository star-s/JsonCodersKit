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

static BOOL isNullValue = NO;

@implementation JCKJsonDecoder

+ (void)setDecodeNullAsValue:(BOOL)nullValue
{
    isNullValue = nullValue;
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
    if (isNullValue) {
        return [self.JSONObject.allKeys containsObject: key];
    } else {
        return [self decodeObjectForKey: key] != nil;
    }
}

- (id)decodeObjectForKey:(NSString *)key
{
    if (isNullValue) {
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
    id result = nil;
    
    if ([aClass jck_supportDirectDecodingFromJsonValue]) {
        //
        id rawValue = [self.JSONObject objectForKey: key];
        result = [aClass jck_decodeFromJsonValue: rawValue];
        
    } else {
        //
        id rawValue = [self decodeObjectForKey: key];
        
        if ([rawValue isKindOfClass: [NSDictionary class]]) {
            //
            JCKJsonDecoder *decoder = [[self.class alloc] initWithJSONObject: rawValue];
            result = [decoder decodeTopLevelObjectOfClass: aClass];
        }
    }
    return result;
}

- (id)decodeTopLevelObjectOfClass:(Class)aClass
{
    id decodedObject = [[aClass alloc] initWithCoder: self];
    return [decodedObject awakeAfterUsingCoder: self];
}

- (NSArray *)decodeArrayObjectsOfClass:(Class)aClass forKey:(NSString *)key
{
    NSArray *result = [self decodeObjectForKey: key];
    
    if ([result isKindOfClass: [NSArray class]]) {
        //
        id (^decodeObjectBlock)(id anObject) = nil;
        
        if ([aClass jck_supportDirectDecodingFromJsonValue]) {
            //
            decodeObjectBlock = ^(id anObject){
                return [aClass jck_decodeFromJsonValue: anObject];
            };
        } else {
            //
            decodeObjectBlock = ^(id anObject){
                JCKJsonDecoder *decoder = [[self.class alloc] initWithJSONObject: anObject];
                return [decoder decodeTopLevelObjectOfClass: aClass];
            };
        }
        result = [result mapWithBlock: decodeObjectBlock];
        
    } else {
        result = nil;
    }
    return result;
}

@end
