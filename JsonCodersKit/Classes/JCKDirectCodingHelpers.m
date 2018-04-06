//
//  JCKDirectCodingHelpers.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 06.04.2018.
//

#import "JCKDirectCodingHelpers.h"

@implementation JCKStringTransformer

- (nullable id)transformedValue:(nullable id)value
{
    if ([value isKindOfClass: [NSString class]]) {
        return [self valueFromString: value];
    } else if ([[value class] isKindOfClass: [self.class transformedValueClass]]) {
        return [self stringFromValue: value];
    }
    return nil;
}

- (id)valueFromString:(NSString *)string
{
    [NSException raise: NSGenericException format: @"Method %@ is abstract, override it!", NSStringFromSelector(_cmd)];
    return nil;
}

- (NSString *)stringFromValue:(id)value
{
    [NSException raise: NSGenericException format: @"Method %@ is abstract, override it!", NSStringFromSelector(_cmd)];
    return nil;
}

@end

NSValueTransformerName const JCKStringToURLTransformerName = @"JCKStringToURLTransformer";

@implementation JCKStringToURLTransformer

+ (Class)transformedValueClass
{
    return [NSURL class];
}

- (NSURL *)valueFromString:(NSString *)string
{
    return [NSURL URLWithString: string];
}

- (NSString *)stringFromValue:(NSURL *)value
{
    return value.absoluteString;
}

@end

NSValueTransformerName const JCKStringToUUIDTransformerName = @"JCKStringToUUIDTransformer";

@implementation JCKStringToUUIDTransformer

+ (Class)transformedValueClass
{
    return [NSUUID class];
}

- (NSUUID *)valueFromString:(NSString *)string
{
    return [[NSUUID alloc] initWithUUIDString: string];
}

- (NSString *)stringFromValue:(NSUUID *)value
{
    return value.UUIDString;
}

@end

NSValueTransformerName const JCKStringToDateTransformerName = @"JCKStringToDateTransformer";

@implementation JCKStringToDateTransformer

+ (Class)transformedValueClass
{
    return [NSDate class];
}

- (instancetype)init
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"]];
    [formatter setDateFormat: @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [formatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 0]];
    
    return [self initWithFormatter: formatter];
}

- (instancetype)initWithFormatter:(NSFormatter *)formatter
{
    self = [super init];
    if (self) {
        _formatter = formatter;
    }
    return self;
}

- (NSDate *)valueFromString:(NSString *)string
{
    NSDate *result = nil;
    
    __kindof NSFormatter *formatter = self.formatter;
    
    if ([formatter respondsToSelector: @selector(dateFromString:)]) {
        result = [formatter dateFromString: string];
    } else {
        [formatter getObjectValue: &result forString: string errorDescription: NULL];
    }
    return result;
}

- (NSString *)stringFromValue:(NSDate *)value
{
    NSString *result = nil;
    
    __kindof NSFormatter *formatter = self.formatter;
    
    if ([formatter respondsToSelector: @selector(stringFromDate:)]) {
        result = [formatter stringFromDate: value];
    } else {
        result = [formatter stringForObjectValue: value];
    }
    return result;
}

@end

NSValueTransformerName const JCKStringToDataTransformerName = @"JCKStringToDataTransformer";

@implementation JCKStringToDataTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

- (instancetype)init
{
    return [self initWithDecodingOptions: kNilOptions encodingOptions: kNilOptions];
}

- (instancetype)initWithDecodingOptions:(NSDataBase64DecodingOptions)decOpts encodingOptions:(NSDataBase64EncodingOptions)encOpts
{
    self = [super init];
    if (self) {
        _decodingOptions = decOpts;
        _encodingOptions = encOpts;
    }
    return self;
}

- (NSData *)valueFromString:(NSString *)string
{
    return [[NSData alloc] initWithBase64EncodedString: string options: self.decodingOptions];
}

- (NSString *)stringFromValue:(NSData *)value
{
    return [value base64EncodedStringWithOptions: self.encodingOptions];
}

@end

#import "Color+HexString.h"

NSValueTransformerName const JCKStringToColorTransformerName = @"JCKStringToColorTransformer";

@implementation JCKStringToColorTransformer

+ (Class)transformedValueClass
{
    return [JCKColor class];
}

- (instancetype)init
{
    return [self initWithExportAlpha: NO];
}

- (instancetype)initWithExportAlpha:(BOOL)value
{
    self = [super init];
    if (self) {
        _exportAlpha = value;
    }
    return self;
}

- (JCKColor *)valueFromString:(NSString *)string
{
    return string.length > 0 ? [JCKColor jck_colorWithHexString: string] : nil;
}

- (NSString *)stringFromValue:(JCKColor *)value
{
    return [value jck_hexStringWithAlpha: self.exportAlpha];
}

@end
