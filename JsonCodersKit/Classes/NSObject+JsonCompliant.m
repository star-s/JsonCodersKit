//
//  NSObject+JsonCompliant.m
//  Pods
//
//  Created by Sergey Starukhin on 02.02.17.
//
//

#import "NSObject+JsonCompliant.h"

@implementation NSObject (JsonCompliant)

+ (BOOL)jck_isJsonCompliant
{
    return NO;
}

+ (id)jck_decodeFromJsonValue:(id)value;
{
    if ([self jck_isJsonCompliant] && [value isKindOfClass: self]) {
        return value;
    } else {
        return nil;
    }
}

- (BOOL)jck_isJsonCompliant
{
    return [self.class jck_isJsonCompliant];
}

- (id)jck_encodedJsonValue
{
    if ([self jck_isJsonCompliant]) {
        return self;
    } else {
        return nil;
    }
}

@end

@implementation NSString (JsonCompliant)

+ (BOOL)jck_isJsonCompliant
{
    return YES;
}

@end

@implementation NSNumber (JsonCompliant)

+ (BOOL)jck_isJsonCompliant
{
    return YES;
}

@end

@implementation NSNull (JsonCompliant)

+ (BOOL)jck_isJsonCompliant
{
    return YES;
}

@end

@implementation NSDictionary (JsonCompliant)

+ (BOOL)jck_isJsonCompliant
{
    return YES;
}

- (BOOL)jck_isJsonCompliant
{
    return [NSJSONSerialization isValidJSONObject: self];
}

@end

@implementation NSArray (JsonCompliant)

+ (BOOL)jck_isJsonCompliant
{
    return YES;
}

- (BOOL)jck_isJsonCompliant
{
    return [NSJSONSerialization isValidJSONObject: self];
}

@end

@implementation NSURL (JsonCompliant)

+ (BOOL)jck_isJsonCompliant
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

- (id)jck_encodedJsonValue
{
    return self.absoluteString;
}

@end

@implementation NSUUID (JsonCompliant)

+ (BOOL)jck_isJsonCompliant
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

- (id)jck_encodedJsonValue
{
    return self.UUIDString;
}

@end
