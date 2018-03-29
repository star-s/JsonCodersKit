//
//  NSObject+DirectCoding.m
//  Pods
//
//  Created by Sergey Starukhin on 14.03.2018.
//

#import "NSObject+DirectCoding.h"

@implementation NSObject (DirectCoding)

#pragma mark - JCKDirectJsonDecoding

+ (BOOL)jck_supportDirectDecodingFromJsonValue
{
    return NO;
}

+ (id)jck_decodeFromJsonValue:(id)value
{
    if ([self jck_supportDirectDecodingFromJsonValue] && [value isKindOfClass: self]) {
        return value;
    } else {
        return nil;
    }
}

#pragma mark - JCKDirectJsonEncoding

- (BOOL)jck_supportDirectEncodingToJsonValue
{
    return [NSJSONSerialization isValidJSONObject: self];
}

- (id)jck_encodeToJsonValue
{
    if ([self jck_supportDirectEncodingToJsonValue]) {
        return self;
    } else {
        return nil;
    }
}

@end

@implementation NSString (DirectCoding)

#pragma mark - JCKDirectJsonDecoding

+ (BOOL)jck_supportDirectDecodingFromJsonValue
{
    return YES;
}

#pragma mark - JCKDirectJsonEncoding

- (BOOL)jck_supportDirectEncodingToJsonValue
{
    return YES;
}

@end

@implementation NSNumber (DirectCoding)

#pragma mark - JCKDirectJsonDecoding

+ (BOOL)jck_supportDirectDecodingFromJsonValue
{
    return YES;
}

#pragma mark - JCKDirectJsonEncoding

- (BOOL)jck_supportDirectEncodingToJsonValue
{
    return YES;
}

@end

@implementation NSNull (DirectCoding)

#pragma mark - JCKDirectJsonDecoding

+ (BOOL)jck_supportDirectDecodingFromJsonValue
{
    return YES;
}

#pragma mark - JCKDirectJsonEncoding

- (BOOL)jck_supportDirectEncodingToJsonValue
{
    return YES;
}

@end

@implementation NSURL (DirectCoding)

#pragma mark - JCKDirectJsonDecoding

+ (BOOL)jck_supportDirectDecodingFromJsonValue
{
    return YES;
}

+ (id)jck_decodeFromJsonValue:(id)value;
{
    if ([value isKindOfClass: [NSString class]]) {
        return [self URLWithString: value];
    } else {
        return nil;
    }
}

#pragma mark - JCKDirectJsonEncoding

- (BOOL)jck_supportDirectEncodingToJsonValue
{
    return YES;
}

- (id)jck_encodeToJsonValue
{
    return self.absoluteString;
}

@end

@implementation NSUUID (DirectCoding)

#pragma mark - JCKDirectJsonDecoding

+ (BOOL)jck_supportDirectDecodingFromJsonValue
{
    return YES;
}

+ (id)jck_decodeFromJsonValue:(id)value;
{
    if ([value isKindOfClass: [NSString class]]) {
        return [[self alloc] initWithUUIDString: value];
    } else {
        return nil;
    }
}

#pragma mark - JCKDirectJsonEncoding

- (BOOL)jck_supportDirectEncodingToJsonValue
{
    return YES;
}

- (id)jck_encodeToJsonValue
{
    return self.UUIDString;
}

@end
