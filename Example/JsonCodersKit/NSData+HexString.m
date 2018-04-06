//
//  NSData+HexString.m
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 06.04.2018.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import "NSData+HexString.h"

@implementation NSData (HexString)

+ (NSData *)dataWithHexString:(NSString *)hexString
{
    NSMutableData *result = [NSMutableData data];
    [NSException raise: NSGenericException format: @"Method %@ not ready!", NSStringFromSelector(_cmd)];
    return result;
}

- (NSString *)hexString
{
    NSMutableString *result = [NSMutableString string];
    
    [self enumerateByteRangesUsingBlock: ^(const void *bytes, NSRange byteRange, BOOL *stop) {
        //
        const uint8_t *ptr = bytes;
        
        for (int i = 0; i < byteRange.length; i++) {
            [result appendFormat: @"%02x", ptr[i]];
        }
    }];
    return result;
}

@end
