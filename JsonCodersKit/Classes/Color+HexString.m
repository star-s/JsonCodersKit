//
//  Color+HexString.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 06.04.2018.
//

//https://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string

#import "Color+HexString.h"

@implementation JCKColor (HexString)

+ (instancetype)jck_colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self jck_colorComponentFrom: colorString start: 0 length: 1];
            green = [self jck_colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self jck_colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self jck_colorComponentFrom: colorString start: 0 length: 1];
            red   = [self jck_colorComponentFrom: colorString start: 1 length: 1];
            green = [self jck_colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self jck_colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self jck_colorComponentFrom: colorString start: 0 length: 2];
            green = [self jck_colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self jck_colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self jck_colorComponentFrom: colorString start: 0 length: 2];
            red   = [self jck_colorComponentFrom: colorString start: 2 length: 2];
            green = [self jck_colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self jck_colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise: @"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [self colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)jck_colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

- (NSString *)jck_hexStringWithAlpha:(BOOL)exportAlpha
{
    NSString *result = nil;
    
    CGFloat red, green, blue, alpha;
    
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
    BOOL colorsAreObtained = YES;
    [self getRed: &red green: &green blue: &blue alpha: &alpha];
#else
    BOOL colorsAreObtained = [self getRed: &red green: &green blue: &blue alpha: &alpha];
#endif
    if (colorsAreObtained) {
        //
        result = @"#";
        
        if (exportAlpha) {
            result = [result stringByAppendingString: [self jck_stringFromComponent: alpha length: 2]];
        }
        result = [result stringByAppendingString: [self jck_stringFromComponent: red length: 2]];
        result = [result stringByAppendingString: [self jck_stringFromComponent: green length: 2]];
        result = [result stringByAppendingString: [self jck_stringFromComponent: blue length: 2]];
    }
    return result;
}

- (NSString *)jck_stringFromComponent:(CGFloat)value length:(NSUInteger)length
{
    uint8_t integerValue = floorf(value * 255.0f);
    NSString *format = length ? [NSString stringWithFormat: @"%%0%@x", @(length)] : @"";
    return [NSString stringWithFormat: format, integerValue];
}

@end

