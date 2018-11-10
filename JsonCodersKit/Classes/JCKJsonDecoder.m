//
//  JCKJsonDecoder.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "JCKJsonDecoder.h"
#import "CollectionMapping.h"
#import "JCKDirectCodingHelpers.h"

@implementation JCKJsonDecoder

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
    return [self.JSONObject.allKeys containsObject: key];
}

- (id)decodeObjectForKey:(NSString *)key
{
    id value = [self.JSONObject objectForKey: key];
    return [value isEqual: [NSNull null]] ? nil : value;
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
    
    NSValueTransformer *helper = [aClass jck_jsonValueTransformer];
    
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
