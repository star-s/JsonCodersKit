//
//  JCKDirectCodingHelpers.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 06.04.2018.
//

#import "JCKDirectCodingHelpers.h"
#import <objc/runtime.h>

@interface NSValueTransformer (JCKPrivate)

+ (void)jck_setJsonValueTransformerOrHisName:(nullable id)transformerOrName forClass:(Class)aClass;

+ (nullable NSValueTransformer *)jck_jsonValueTransformerForClass:(Class)aClass;

@end

@implementation NSValueTransformer (JCKPrivate)

+ (NSMapTable *)transformersMap
{
    static NSMapTable *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = [NSMapTable strongToStrongObjectsMapTable];
    });
    return map;
}

+ (void)jck_setJsonValueTransformerOrHisName:(id)obj forClass:(Class)aClass
{
    NSString *key = NSStringFromClass(aClass);
    NSMapTable *map = self.transformersMap;
    if (obj) {
        NSAssert([obj isKindOfClass: [NSString class]] || [obj isKindOfClass: [NSValueTransformer class]], @"%@ is not NSString or NSValueTransformer", obj);
        [map setObject: obj forKey: key];
    } else {
        [map removeObjectForKey: key];
    }
}

+ (NSValueTransformer *)jck_jsonValueTransformerForClass:(Class)aClass
{
    NSString *key = NSStringFromClass(aClass);
    id result = [self.transformersMap objectForKey: key];
    if (!result) {
        static NSDictionary *defaultTransformers = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            defaultTransformers = @{
                                    @"NSString"     : JCKStringFromJsonTransformerName,
                                    @"NSNull"       : JCKNullFromJsonTransformerName,
                                    @"NSNumber"     : JCKNumberFromJsonTransformerName,
                                    @"NSDictionary" : JCKDictionaryFromJsonTransformerName,
                                    @"NSArray"      : JCKArrayFromJsonTransformerName,
                                    @"NSURL"        : JCKURLFromJsonTransformerName,
                                    @"NSUUID"       : JCKUUIDFromJsonTransformerName,
                                    @"NSDate"       : JCKDateFromJsonTransformerName,
                                    @"NSData"       : JCKDataFromJsonTransformerName,
                                    @"UIColor"      : JCKColorFromJsonTransformerName,
                                    @"NSColor"      : JCKColorFromJsonTransformerName
                                    };
        });
        result = defaultTransformers[key];
    }
    return [result isKindOfClass: [NSString class]] ? [self valueTransformerForName: result] : result;
}

@end

@implementation NSObject (JCKHelpers)

+ (void)jck_setJsonValueTransformerOrHisName:(id)transformerOrName
{
    [NSValueTransformer jck_setJsonValueTransformerOrHisName: transformerOrName forClass: self];
}

+ (NSValueTransformer *)jck_jsonValueTransformer
{
    return [NSValueTransformer jck_jsonValueTransformerForClass: self];
}

- (NSValueTransformer *)jck_jsonValueTransformer
{
    __block NSValueTransformer *result = nil;
    
    [self.jck_classHierarchy enumerateObjectsUsingBlock: ^(Class class, NSUInteger idx, BOOL *stop) {
        result = [class jck_jsonValueTransformer];
        *stop = [[result class] allowsReverseTransformation];
    }];
    return result;
}

- (NSArray <Class> *)jck_classHierarchy
{
    NSMutableArray <Class> *classes = [NSMutableArray array];
    Class aClass = [self class];
    do {
        [classes addObject: aClass];
        aClass = [aClass superclass];
    } while (aClass);
    return [classes copy];
}

@end

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
    }
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

- (id)reverseTransformedValue:(id)value
{
    if (![value isKindOfClass: self.class.transformedValueClass]) {
        return nil;
    }
    return [NSJSONSerialization isValidJSONObject: value] ? value : nil;
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

- (id)reverseTransformedValue:(id)value
{
    if (![value isKindOfClass: self.class.transformedValueClass]) {
        return nil;
    }
    return [NSJSONSerialization isValidJSONObject: value] ? value : nil;
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
