//
//  JCKDirectCodingHelpers.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 06.04.2018.
//

#import "JCKDirectCodingHelpers.h"

#pragma mark - JSON values without coding

NSValueTransformerName const JCKStringFromJsonTransformerName = @"JCKStringFromJsonTransformer";

@implementation JCKStringFromJsonTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

- (NSString *)transformedValue:(id)value
{
    if ([value isKindOfClass: self.class.transformedValueClass]) {
        return value;
    } else if ([value respondsToSelector: @selector(stringValue)]) {
        return [value stringValue];
    }
    return nil;
}

@end

NSValueTransformerName const JCKNullFromJsonTransformerName = @"JCKNullFromJsonTransformer";

@implementation JCKNullFromJsonTransformer

+ (Class)transformedValueClass
{
    return [NSNull class];
}

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: self.class.transformedValueClass]) {
        return value;
    }
    return nil;
}

@end

NSValueTransformerName const JCKNumberFromJsonTransformerName = @"JCKNumberFromJsonTransformer";

@implementation JCKNumberFromJsonTransformer

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: self.class.transformedValueClass]) {
        return value;
    }/*
    if ([value respondsToSelector: @selector(integerValue)]) {
        return [NSNumber numberWithInteger: [value integerValue]];
    }
    if ([value respondsToSelector: @selector(doubleValue)]) {
        return [NSNumber numberWithDouble: [value doubleValue]];
    }
    if ([value respondsToSelector: @selector(boolValue)]) {
        return [NSNumber numberWithBool: [value boolValue]];
    }*/
    return nil;
}

@end

NSValueTransformerName const JCKDictionaryFromJsonTransformerName = @"JCKDictionaryFromJsonTransformer";

@implementation JCKDictionaryFromJsonTransformer

+ (Class)transformedValueClass
{
    return [NSDictionary class];
}

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: self.class.transformedValueClass]) {
        return value;
    }
    return nil;
}

@end

NSValueTransformerName const JCKArrayFromJsonTransformerName = @"JCKArrayFromJsonTransformer";

@implementation JCKArrayFromJsonTransformer

+ (Class)transformedValueClass
{
    return [NSArray class];
}

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: self.class.transformedValueClass]) {
        return value;
    }
    return nil;
}

@end

#pragma mark - JSON values with coding

NSValueTransformerName const JCKURLFromJsonTransformerName = @"JCKURLFromJsonTransformer";

@implementation JCKURLFromJsonTransformer

+ (Class)transformedValueClass
{
    return [NSURL class];
}

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: [NSString class]]) {
        return [NSURL URLWithString: value];
    }
    return nil;
}

- (id)reverseTransformedValue:(NSURL *)value
{
    if (![value isKindOfClass: self.class.transformedValueClass]) {
        return nil;
    }
    return value.absoluteString;
}

@end

NSValueTransformerName const JCKUUIDFromJsonTransformerName = @"JCKUUIDFromJsonTransformer";

@implementation JCKUUIDFromJsonTransformer

+ (Class)transformedValueClass
{
    return [NSUUID class];
}

- (instancetype)init
{
    return [self initWithConversionToLowercaseString: YES];
}

- (instancetype)initWithConversionToLowercaseString:(BOOL)convert
{
    self = [super init];
    if (self) {
        _convertToLowercaseString = convert;
    }
    return self;
}

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: [NSString class]]) {
        return [[NSUUID alloc] initWithUUIDString: value];
    }
    return nil;
}

- (id)reverseTransformedValue:(NSUUID *)value
{
    if (![value isKindOfClass: self.class.transformedValueClass]) {
        return nil;
    }
    NSString *result = value.UUIDString;
    return self.convertToLowercaseString ? result.lowercaseString : result;
}

@end

NSValueTransformerName const JCKDateFromJsonTransformerName = @"JCKDateFromJsonTransformer";

@implementation JCKDateFromJsonTransformer

+ (Class)transformedValueClass
{
    return [NSDate class];
}

- (instancetype)init
{
    if (@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)) {
        return [self initWithFormatter: [[NSISO8601DateFormatter alloc] init]];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssXXXXX";
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT: 0];
        
        return [self initWithFormatter: formatter];
    }
}

- (instancetype)initWithFormatter:(NSFormatter *)formatter
{
    self = [super init];
    if (self) {
        _formatter = formatter;
    }
    return self;
}

- (id)transformedValue:(id)value
{
    if (![value isKindOfClass: [NSString class]]) {
        return nil;
    }
    NSDate *result = nil;
    
    __kindof NSFormatter *formatter = self.formatter;
    
    if ([formatter respondsToSelector: @selector(dateFromString:)]) {
        result = [formatter dateFromString: value];
    } else {
        [formatter getObjectValue: &result forString: value errorDescription: NULL];
    }
    return result;
}

- (id)reverseTransformedValue:(id)value
{
    if (![value isKindOfClass: self.class.transformedValueClass]) {
        return nil;
    }
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

NSValueTransformerName const JCKUnixDateFromJsonTransformerName = @"JCKUnixDateFromJsonTransformer";

@implementation JCKUnixDateFromJsonTransformer

+ (Class)transformedValueClass
{
    return [NSDate class];
}

- (id)transformedValue:(id)value
{
    NSTimeInterval interval = 0.0;
    if ([value respondsToSelector: @selector(doubleValue)]) {
        interval = [value doubleValue];
    } else if ([value respondsToSelector: @selector(floatValue)]) {
        interval = [value floatValue];
    }
    return interval > 0.0 ? [NSDate dateWithTimeIntervalSince1970: interval] : nil;
}

- (id)reverseTransformedValue:(NSDate *)value
{
    if (![value isKindOfClass: self.class.transformedValueClass]) {
        return nil;
    }
    return [NSNumber numberWithDouble: value.timeIntervalSince1970];
}

@end

NSValueTransformerName const JCKDataFromJsonTransformerName = @"JCKDataFromJsonTransformer";

@implementation JCKDataFromJsonTransformer

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

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: [NSString class]]) {
        return [[NSData alloc] initWithBase64EncodedString: value options: self.decodingOptions];
    }
    return nil;
}

- (id)reverseTransformedValue:(NSData *)value
{
    if (![value isKindOfClass: self.class.transformedValueClass]) {
        return nil;
    }
    return [value base64EncodedStringWithOptions: self.encodingOptions];
}

@end

#import "Color+HexString.h"

NSValueTransformerName const JCKColorFromJsonTransformerName = @"JCKColorFromJsonTransformer";

@implementation JCKColorFromJsonTransformer

+ (Class)transformedValueClass
{
    return [JCKColor class];
}

- (instancetype)init
{
    return [self initWithExportAlpha: YES];
}

- (instancetype)initWithExportAlpha:(BOOL)value
{
    self = [super init];
    if (self) {
        _exportAlpha = value;
    }
    return self;
}

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: [NSString class]] && ([value length] > 0)) {
        return [JCKColor jck_colorWithHexString: value];
    }
    return nil;
}

- (id)reverseTransformedValue:(JCKColor *)value
{
    if (![value isKindOfClass: self.class.transformedValueClass]) {
        return nil;
    }
    return [value jck_hexStringWithAlpha: self.exportAlpha];
}

@end
