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

// decode json
- (id)transformedValue:(id)value
{
    Class resultValueClass = self.transformedValueClass;
    if ([value isKindOfClass: resultValueClass]) {
        return value;
    }
    if ([value isKindOfClass: [NSArray class]]) {
        return [value transformedArray: self];
    } else {
        id result = nil;
        
        NSValueTransformer *helper = [JCKJsonDecoder transformerForClass: resultValueClass];
        if (helper) {
            result = [helper transformedValue: value];
        } else if ([value isKindOfClass: [NSDictionary class]]) {
            JCKJsonDecoder *coder = [[JCKJsonDecoder alloc] initWithJSONObject: value];
            result = [coder decodeTopLevelObjectOfClass: resultValueClass];
        }
        return result;
    }
}

// encode json
- (id)reverseTransformedValue:(id)value
{
    if ([value isKindOfClass: [NSArray class]]) {
        return [value transformedArray: self reverseTransformation: YES];
    } else {
        id result = nil;
        if ([value isKindOfClass: self.transformedValueClass]) {
            // Reverse transformation Obj -> Json
            NSValueTransformer *encoderHelper = [JCKJsonEncoder transformerForClass: [value class]];
            if (encoderHelper) {
                result = [encoderHelper transformedValue: value];
            } else {
                NSValueTransformer *helper = [JCKJsonEncoder reversedTransformerForClass: [value class]];
                if (helper) {
                    result = [helper reverseTransformedValue: value];
                } else if ([value conformsToProtocol: @protocol(NSCoding)]) {
                    JCKJsonEncoder *coder = [[JCKJsonEncoder alloc] init];
                    [coder encodeRootObject: value];
                    result = coder.encodedJSONObject;
                }
            }
        }
        return result;
    }
}

@end
