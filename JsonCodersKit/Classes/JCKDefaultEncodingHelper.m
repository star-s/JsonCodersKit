//
//  JCKDefaultEncodingHelper.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 21.05.2018.
//

#import "JCKDefaultEncodingHelper.h"
#import "NSObject+DirectCoding.h"
#import "Color+HexString.h"
#import <objc/runtime.h>

@interface NSObject (canonicalClass)

+ (Class)canonicalClass;

- (Class)canonicalClass;

@end

@interface NSString (RemovePrefixes)

- (NSString *)jck_stringByRemovingPrefixes:(NSArray *)prefixes;

@end

@implementation JCKDefaultEncodingHelper

- (instancetype)init
{
    return [self initWithEncodeNilAsNull: NO];
}

- (instancetype)initWithEncodeNilAsNull:(BOOL)encode
{
    self = [super init];
    if (self) {
        _encodeNilAsNull = encode;
    }
    return self;
}

- (id)encoder:(JCKJsonEncoder *)coder encodeJsonObjectFromValue:(id)value
{
    if ([value jck_isValidJSONObject]) { // No encoding needed
        return value;
    }
    if (!value) {
        return [self isEncodeNilAsNull] ? [NSNull null] : nil;
    }
    NSString *valueClassName = [NSStringFromClass([value canonicalClass]) jck_stringByRemovingPrefixes: @[@"NS", @"UI"]];
    
    SEL selector = NSSelectorFromString([NSString stringWithFormat: @"encode%@:", valueClassName]);
    if ([self respondsToSelector: selector]) {
        return [self performSelector: selector withObject: value];
    } else {
        JCKJsonEncoder *encoder = [[coder.class alloc] init];
        [encoder encodeRootObject: value];
        return encoder.encodedJSONObject;
    }
}

#pragma mark - UUID

- (NSString *)encodeUUID:(NSUUID *)value
{
    return value.UUIDString;
}

#pragma mark - NSURL

- (NSString *)encodeURL:(NSURL *)value
{
    return value.absoluteString;
}

#pragma mark - Data

- (NSDataBase64EncodingOptions)encodingOptions
{
    return kNilOptions;
}

- (id)encodeData:(NSData *)value
{
    return [value base64EncodedStringWithOptions: self.encodingOptions];
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

- (id)encodeDate:(NSDate *)value
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

#pragma mark - Color

- (BOOL)exportAlpha
{
    return NO;
}

- (id)encodeColor:(id)value
{
    return [value jck_hexStringWithAlpha: self.exportAlpha];
}

@end
