//
//  UIColor+DirectCoding.m
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 20.03.2018.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import "UIColor+DirectCoding.h"
#import "UIColor+HexString.h"

@implementation UIColor (DirectCoding)

static BOOL encodeAlpha = NO;

+ (void)addAlphaWhenCodingToJson:(BOOL)value
{
    encodeAlpha = value;
}

#pragma mark - JCKDirectJsonDecoding

+ (BOOL)jck_supportDirectDecodingFromJsonValue
{
    return YES;
}

+ (id)jck_decodeFromJsonValue:(id)value;
{
    if ([value isKindOfClass: [NSString class]]) {
        return [self colorWithHexString: value];
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
    return [self hexStringWithAlpha: encodeAlpha];
}

@end
