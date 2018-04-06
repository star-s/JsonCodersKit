//
//  JCKJsonToObjectTransformer.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "JCKJsonToObjectTransformer.h"
#import "JCKJsonDecoder.h"
#import "JCKJsonEncoder.h"
#import "CollectionMapping.h"
#import "NSObject+DirectCoding.h"

@implementation JCKJsonToObjectTransformer

+ (Class)transformedValueClass
{
    [NSException raise: NSInternalInconsistencyException format: @"Metod %@ must be overrided in class %@", NSStringFromSelector(_cmd), NSStringFromClass(self)];
    return nil;
}

- (instancetype)init
{
    return [self initWithTransformedValueClass: [self.class transformedValueClass]];
}

- (instancetype)initWithTransformedValueClass:(Class)aClass
{
    self = [super init];
    if (self) {
        _transformedValueClass = aClass;
    }
    return self;
}

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: self.transformedValueClass]) {
        return value;
    }
    if ([value isKindOfClass: [NSArray class]]) {
        return [value transformedArray: self];
    } else {
        id result = nil;
        
        NSValueTransformer *helper = [self.transformedValueClass jck_directCodingHelper];
        
        if ([value jck_isValidJSONObject]) {
            // Forward transformation Json -> Obj
            if ([value isKindOfClass: self.transformedValueClass]) {
                result = value;
            } else if (helper) {
                result = [helper transformedValue: value];
            } else if ([value isKindOfClass: [NSDictionary class]]) {
                JCKJsonDecoder *coder = [[JCKJsonDecoder alloc] initWithJSONObject: value];
                result = [coder decodeTopLevelObjectOfClass: self.transformedValueClass];
            }
        } else if ([value isKindOfClass: self.transformedValueClass]) {
            // Reverse transformation Obj -> Json
            if (helper) {
                result = [helper reverseTransformedValue: value];
            } else {
                JCKJsonEncoder *coder = [[JCKJsonEncoder alloc] init];
                [coder encodeRootObject: value];
                result = [coder encodedJSONObject];
            }
        }
        return result;
    }
}

@end
