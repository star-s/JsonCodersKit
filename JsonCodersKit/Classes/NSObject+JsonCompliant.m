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

- (BOOL)jck_isJsonCompliant
{
    return [self.class jck_isJsonCompliant];
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
