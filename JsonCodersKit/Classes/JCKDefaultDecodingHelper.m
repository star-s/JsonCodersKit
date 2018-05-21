//
//  JCKDefaultDecodingHelper.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 21.05.2018.
//

#import "JCKDefaultDecodingHelper.h"
#import "Color+HexString.h"
#import <objc/runtime.h>

@interface NSObject (canonicalClass)

+ (Class)canonicalClass;

- (Class)canonicalClass;

@end

@implementation NSObject (canonicalClass)

+ (Class)canonicalClass
{
    static NSArray *canonicalClasses = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        canonicalClasses = @[
                             [NSString class],
                             [NSNumber class],
                             [NSData class],
                             [NSDate class],
                             [NSUUID class],
                             [NSURL class],
                             [JCKColor class],
                             [NSNull class]
                             ];
    });
    __block Class result = self;
    [canonicalClasses enumerateObjectsUsingBlock: ^(Class _Nonnull canonicalClass, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        if ([self isSubclassOfClass: canonicalClass]) {
            result = canonicalClass;
            *stop = YES;
        }
    }];
    return result;
}

- (Class)canonicalClass
{
    return [[self class] canonicalClass];
}

@end

@interface NSString (RemovePrefixes)

- (NSString *)jck_stringByRemovingPrefixes:(NSArray *)prefixes;

@end

@implementation NSString (RemovePrefixes)

- (NSString *)jck_stringByRemovingPrefixes:(NSArray *)prefixes
{
    NSString *result = self;
    for (NSString *prefix in prefixes) {
        if ([result hasPrefix: prefix]) {
            result = [result substringFromIndex: prefix.length];
        }
    }
    return result;
}

@end

@implementation JCKDefaultDecodingHelper

- (nullable id)decoder:(JCKJsonDecoder *)coder convertValue:(nullable id)value toObjectOfClass:(Class)aClass
{
    if (!value || [value isKindOfClass: aClass]) { // No decoding needed
        return value;
    }
    if ([value isKindOfClass: [NSString class]] || [value isKindOfClass: [NSNumber class]]) {
        //
        NSString *clasName = [NSStringFromClass(aClass) jck_stringByRemovingPrefixes: @[@"NS", @"UI"]];
        NSString *valueClassName = [NSStringFromClass([value canonicalClass]) jck_stringByRemovingPrefixes: @[@"NS", @"UI"]];
        
        SEL selector = NSSelectorFromString([NSString stringWithFormat: @"decode%@From%@:", clasName, valueClassName]);
        if ([self respondsToSelector: selector]) {
            return [self performSelector: selector withObject: value];
        }
    } else if ([value isKindOfClass: [NSDictionary class]] && [aClass conformsToProtocol: @protocol(NSCoding)]) {
        JCKJsonDecoder *decoder = [[coder.class alloc] initWithJSONObject: value];
        return [decoder decodeTopLevelObjectOfClass: aClass];
    }
    return nil;
}

#pragma mark - UUID

- (NSUUID *)decodeUUIDFromString:(NSString *)value
{
    return [[NSUUID alloc] initWithUUIDString: value];
}

#pragma mark - URL

- (NSURL *)decodeURLFromString:(NSString *)value
{
    return [NSURL URLWithString: value];
}

#pragma mark - Data

- (NSDataBase64DecodingOptions)decodingOptions
{
    return kNilOptions;
}

- (NSData *)decodeDataFromString:(NSString *)value
{
    return [[NSData alloc] initWithBase64EncodedString: value options: self.decodingOptions];
}

#pragma mark - Date

- (NSFormatter *)formatter
{
    NSFormatter *result = objc_getAssociatedObject(self, _cmd);
    if (!result) {
        //
        if (@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)) {
            result = [[NSISO8601DateFormatter alloc] init];
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssXXXXX";
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT: 0];
            
            result = formatter;
        }
        objc_setAssociatedObject(self, _cmd, result, OBJC_ASSOCIATION_RETAIN);
    }
    return result;
}

- (NSDate *)decodeDateFromString:(NSString *)value
{
    NSDate *result = nil;
    
    __kindof NSFormatter *formatter = self.formatter;
    
    if ([formatter respondsToSelector: @selector(dateFromString:)]) {
        result = [formatter dateFromString: value];
    } else {
        [formatter getObjectValue: &result forString: value errorDescription: NULL];
    }
    return result;
}

- (NSDate *)decodeDateFromNumber:(NSNumber *)value
{
    return [NSDate dateWithTimeIntervalSince1970: value.doubleValue];
}

#pragma mark - String

- (NSString *)decodeStringFromNumber:(NSNumber *)value
{
    return [value stringValue];
}

#pragma mark - Color

- (id)decodeColorFromString:(NSString *)value
{
    return value.length > 0 ? [JCKColor jck_colorWithHexString: value] : nil;
}

- (id)decodeColorFromNumber:(NSNumber *)value
{
    return nil;
}

@end
