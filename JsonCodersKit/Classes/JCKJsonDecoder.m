//
//  JCKJsonDecoder.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "JCKJsonDecoder.h"
#import "NSObject+JsonCompliant.h"
#import "CollectionMapping.h"

@implementation JCKJsonDecoder

- (instancetype)initWithJSONObject:(NSDictionary *)obj
{
    NSParameterAssert([obj isKindOfClass: [NSDictionary class]]);
    self = [super init];
    if (self) {
        //
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
    return [self decodeObjectForKey: key] != nil;
}

- (id)decodeObjectForKey:(NSString *)key
{
    id result = [self.JSONObject objectForKey: key];
    return [result isEqual: [NSNull null]] ? nil : result;
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
    
    if ([aClass jck_isJsonCompliant]) {
        //
        id rawValue = [self.JSONObject objectForKey: key];
        result = [rawValue isKindOfClass: aClass] ? rawValue : nil;
        
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
        result = [result mapWithBlock: ^(id anObject){
            //
            JCKJsonDecoder *decoder = [[self.class alloc] initWithJSONObject: anObject];
            return [decoder decodeTopLevelObjectOfClass: aClass];
        }];
        
    } else {
        result = nil;
    }
    return result;
}

@end
