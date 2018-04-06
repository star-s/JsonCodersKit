//
//  NSData+DirectCoding.m
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 06.04.2018.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import "NSData+DirectCoding.h"

@implementation NSData (DirectCoding)

static NSDataBase64DecodingOptions decodeOptions = kNilOptions;
static NSDataBase64EncodingOptions encodeOptions = kNilOptions;

+ (void)setJsonDecodingOptions:(NSDataBase64DecodingOptions)opts
{
    decodeOptions = opts;
}

+ (void)setJsonEncodingOptions:(NSDataBase64EncodingOptions)opts
{
    encodeOptions = opts;
}

#pragma mark - JCKDirectJsonDecoding

+ (BOOL)jck_supportDirectDecodingFromJsonValue
{
    return YES;
}

+ (id)jck_decodeFromJsonValue:(id)value;
{
    if ([value isKindOfClass: [NSString class]]) {
        return [[self alloc] initWithBase64EncodedString: value options: decodeOptions];
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
    return [self base64EncodedStringWithOptions: encodeOptions];
}

@end
