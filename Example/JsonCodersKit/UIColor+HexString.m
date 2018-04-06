//
//  UIColor+HexString.m
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 09.12.15.
//  Copyright © 2015 Sergey Starukhin. All rights reserved.
//

//https://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise: @"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

- (NSString *)hexString
{
    return [self hexStringWithAlpha: NO];
}

- (NSString *)hexStringWithAlpha:(BOOL)exportAlpha
{
    NSString *result = nil;
    
    CGFloat red, green, blue, alpha;
    
    if ([self getRed: &red green: &green blue: &blue alpha: &alpha]) {
        //
        result = @"#";
        
        if (exportAlpha) {
            result = [result stringByAppendingString: [self stringFromComponent: alpha length: 2]];
        }
        result = [result stringByAppendingString: [self stringFromComponent: red length: 2]];
        result = [result stringByAppendingString: [self stringFromComponent: green length: 2]];
        result = [result stringByAppendingString: [self stringFromComponent: blue length: 2]];
    }
    return result;
}

- (NSString *)stringFromComponent:(CGFloat)value length:(NSUInteger)length
{
    uint8_t integerValue = floorf(value * 255.0f);
    NSString *format = length ? [NSString stringWithFormat: @"%%0%@x", @(length)] : @"";
    return [NSString stringWithFormat: format, integerValue];
}

@end
