//
//  NSDate+DirectCoding.m
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 20.03.2018.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import "NSDate+DirectCoding.h"

static __kindof NSFormatter *formatter = nil;


static NSString *NSStringFromDate(NSDate *date) {
    NSString *result = nil;
    
    if ([formatter respondsToSelector: @selector(stringFromDate:)]) {
        result = [formatter stringFromDate: date];
    } else {
        result = [formatter stringForObjectValue: date];
    }
    return result;
}

static NSDate *NSDateFromString(NSString *string) {
    NSDate *result = nil;
    
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
    @synchronized(formatter) {
        formatter = codingFormatter;
    }
}

#pragma mark - JCKDirectJsonDecoding

+ (BOOL)jck_supportDirectDecodingFromJsonValue
{
    return formatter != nil;
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
    return formatter != nil;
}

- (id)jck_encodeToJsonValue
{
    return NSStringFromDate(self);
}

@end
