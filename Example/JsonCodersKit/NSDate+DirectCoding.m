//
//  NSDate+DirectCoding.m
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 20.03.2018.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import "NSDate+DirectCoding.h"

static NSFormatter *sharedFormatter = nil;

static NSString * const syncToken = @"syncToken";

static NSString *NSStringFromDate(NSDate *date) {
    NSString *result = nil;
    
    __kindof NSFormatter *formatter = nil;
    
    @synchronized(syncToken) {
        formatter = sharedFormatter;
    }
    if ([formatter respondsToSelector: @selector(stringFromDate:)]) {
        result = [formatter stringFromDate: date];
    } else {
        result = [formatter stringForObjectValue: date];
    }
    return result;
}

static NSDate *NSDateFromString(NSString *string) {
    NSDate *result = nil;
    
    __kindof NSFormatter *formatter = nil;
    
    @synchronized(syncToken) {
        formatter = sharedFormatter;
    }
    if ([formatter respondsToSelector: @selector(dateFromString:)]) {
        result = [formatter dateFromString: string];
    } else {
        [formatter getObjectValue: &result forString: string errorDescription: NULL];
    }
    return result;
}

@implementation NSDate (DirectCoding)

+ (void)setJsonCodingFormatter:(NSFormatter *)codingFormatter
{
    @synchronized(syncToken) {
        sharedFormatter = codingFormatter;
    }
}

#pragma mark - JCKDirectJsonDecoding

+ (BOOL)jck_supportDirectDecodingFromJsonValue
{
    @synchronized(syncToken) {
        return sharedFormatter != nil;
    }
}

+ (id)jck_decodeFromJsonValue:(id)value;
{
    if ([value isKindOfClass: [NSString class]]) {
        return NSDateFromString(value);
    } else {
        return nil;
    }
}

#pragma mark - JCKDirectJsonEncoding

- (BOOL)jck_supportDirectEncodingToJsonValue
{
    @synchronized(syncToken) {
        return sharedFormatter != nil;
    }
}

- (id)jck_encodeToJsonValue
{
    return NSStringFromDate(self);
}

@end
