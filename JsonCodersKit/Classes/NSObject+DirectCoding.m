//
//  NSObject+DirectCoding.m
//  Pods
//
//  Created by Sergey Starukhin on 14.03.2018.
//

#import "NSObject+DirectCoding.h"
#import <objc/runtime.h>

@implementation NSObject (DirectCoding)

static void * kHelperKey = &kHelperKey;

+ (NSValueTransformer *)jck_directCodingHelper
{
    id result = objc_getAssociatedObject(self, kHelperKey);
    return result ? result : [[self superclass] jck_directCodingHelper];
}

+ (void)setJck_directCodingHelper:(NSValueTransformer *)helper
{
    objc_setAssociatedObject(self, kHelperKey, helper, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)jck_isValidJSONObject
{
    static NSArray *simpleJsonClasses = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simpleJsonClasses = @[[NSString class], [NSNumber class], [NSNull class]];
    });
    return [simpleJsonClasses containsObject: [self class]] || [NSJSONSerialization isValidJSONObject: self];
}

@end

@interface JCKStringCodingHelper : NSValueTransformer
@end

@implementation JCKStringCodingHelper

+ (Class)transformedValueClass
{
    return [NSString class];
}

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: [NSNull class]]) {
        return nil;
    }
    if ([value isKindOfClass: [self.class transformedValueClass]]) {
        return value;
    }
    if ([value respondsToSelector: @selector(stringValue)]) {
        return [value stringValue];
    }
    return nil;
}

@end

@implementation NSString (DirectCoding)

+ (void)load
{
    [self setJck_directCodingHelper: [[JCKStringCodingHelper alloc] init]];
}

@end

@interface JCKNumberCodingHelper : NSValueTransformer
@end

@implementation JCKNumberCodingHelper

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

- (NSNumber *)transformedValue:(id)value
{
    if ([value isKindOfClass: [NSNull class]]) {
        return nil;
    }
    if ([value isKindOfClass: [self.class transformedValueClass]]) {
        return value;
    }
    return nil;
}

- (id)reverseTransformedValue:(id)value
{
    if ([value isKindOfClass: [NSNull class]]) {
        return nil;
    }
    if ([value isKindOfClass: [self.class transformedValueClass]]) {
        return [value stringValue];
    }
    return nil;
}

@end

@implementation NSNumber (DirectCoding)

+ (void)load
{
    [self setJck_directCodingHelper: [[JCKNumberCodingHelper alloc] init]];
}

@end

@implementation NSNull (DirectCoding)

+ (void)load
{
    [self setJck_directCodingHelper: [[NSValueTransformer alloc] init]];
}

@end

#import "JCKDirectCodingHelpers.h"

@implementation NSURL (DirectCoding)

+ (void)load
{
    [self setJck_directCodingHelper: [NSValueTransformer valueTransformerForName: JCKStringToURLTransformerName]];
}

@end

@implementation NSUUID (DirectCoding)

+ (void)load
{
    [self setJck_directCodingHelper: [NSValueTransformer valueTransformerForName: JCKStringToUUIDTransformerName]];
}

@end

@implementation NSData (DirectCoding)

+ (void)load
{
    [self setJck_directCodingHelper: [NSValueTransformer valueTransformerForName: JCKStringToDataTransformerName]];
}

@end

@implementation NSDate (DirectCoding)

+ (void)load
{
    [self setJck_directCodingHelper: [NSValueTransformer valueTransformerForName: JCKStringToDateTransformerName]];
}

@end

#import "Color+HexString.h"

@implementation JCKColor (DirectCoding)

+ (void)load
{
    [self setJck_directCodingHelper: [NSValueTransformer valueTransformerForName: JCKStringToColorTransformerName]];
}

@end
