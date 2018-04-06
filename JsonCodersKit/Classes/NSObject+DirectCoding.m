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

@implementation NSString (DirectCoding)

+ (void)load
{
    [self setJck_directCodingHelper: [[NSValueTransformer alloc] init]];
}

@end

@implementation NSNumber (DirectCoding)

+ (void)load
{
    [self setJck_directCodingHelper: [[NSValueTransformer alloc] init]];
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
