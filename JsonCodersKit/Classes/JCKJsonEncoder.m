//
//  JCKJsonEncoder.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "JCKJsonEncoder.h"
#import "CollectionMapping.h"
#import "JCKDirectCodingHelpers.h"

@interface JCKJsonEncoder ()

@property (nonatomic, strong, readonly) NSMutableDictionary *dictionary;

@end

@implementation JCKJsonEncoder

static BOOL encodeNilValue = NO;

+ (void)setEncodeNilValue:(BOOL)encodeNil
{
    encodeNilValue = encodeNil;
}

- (instancetype)init
{
    return [self initWithMutableDictionary: [NSMutableDictionary dictionary]];
}

- (instancetype)initWithMutableDictionary:(NSMutableDictionary *)dictionary
{
    NSParameterAssert(dictionary != nil);
    self = [super init];
    if (self) {
        _dictionary = dictionary;
    }
    return self;
}

- (NSDictionary *)encodedJSONObject
{
    NSAssert([NSJSONSerialization isValidJSONObject: self.dictionary], @"%@ is not valod JSON object", self.dictionary);
    return [self.dictionary copy];
}

- (BOOL)allowsKeyedCoding
{
    return YES;
}

- (void)encodeRootObject:(id)rootObject
{
    id objectForCoding = [rootObject replacementObjectForCoder: self];
    
    if ([objectForCoding isKindOfClass: [NSDictionary class]]) {
        //
        if ([NSJSONSerialization isValidJSONObject: objectForCoding]) {
            [self.dictionary addEntriesFromDictionary: objectForCoding];
        } else {
            [NSException raise: NSInvalidArgumentException format: @"It's not valid JSON object %@", objectForCoding];
        }
    } else {
        [objectForCoding encodeWithCoder: self];
    }
}

- (void)encodeObject:(nullable id)objv forKey:(NSString *)key
{
    self.dictionary[key] = [self jsonObjectFromObject: objv];
}

- (void)encodeBool:(BOOL)boolv forKey:(NSString *)key
{
    [self.dictionary setObject: [NSNumber numberWithBool: boolv] forKey: key];
}

- (void)encodeInt:(int)intv forKey:(NSString *)key
{
    [self.dictionary setObject: [NSNumber numberWithInt: intv] forKey: key];
}

- (void)encodeFloat:(float)realv forKey:(NSString *)key
{
    [self.dictionary setObject: [NSNumber numberWithFloat: realv] forKey: key];
}

- (void)encodeDouble:(double)realv forKey:(NSString *)key
{
    [self.dictionary setObject: [NSNumber numberWithDouble: realv] forKey: key];
}

- (void)encodeInteger:(NSInteger)intv forKey:(NSString *)key
{
    [self.dictionary setObject: [NSNumber numberWithInteger: intv] forKey: key];
}

- (void)encodeInt32:(int32_t)intv forKey:(NSString *)key
{
    [self encodeInt: intv forKey: key];
}

- (void)encodeInt64:(int64_t)intv forKey:(NSString *)key
{
    [self.dictionary setObject: [NSNumber numberWithLongLong: intv] forKey: key];
}

- (id)jsonObjectFromObject:(id)object
{
    if (object == nil) {
        return encodeNilValue ? [NSNull null] : object;
    }
    if ([object isKindOfClass: [NSArray class]]) {
        return [(NSArray *)object mapWithBlock: ^(id anObject) {
            return [self jsonObjectFromObject: anObject];
        }];
    }
    id encodedObject = nil;
    
    NSValueTransformer *helper = [object jck_jsonValueTransformer];
    if (helper) {
        encodedObject = [helper reverseTransformedValue: object];
    } else if ([object conformsToProtocol: @protocol(NSCoding)]) {
        JCKJsonEncoder *coder = [[self.class alloc] init];
        [coder encodeRootObject: object];
        encodedObject = coder.encodedJSONObject;
    }
    return encodedObject;
}

@end
