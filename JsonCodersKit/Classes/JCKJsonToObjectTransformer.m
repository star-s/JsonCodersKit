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
    id result = nil;
    
    if ([value isKindOfClass: [NSArray class]]) {
        //
        result = [value transformedArray: self];
        
    } else if ([value isKindOfClass: self.transformedValueClass]) {
        // Reverse transformation
        if ([value jck_supportDirectEncodingToJsonValue]) {
            result = [value jck_encodeToJsonValue];
        } else {
            JCKJsonEncoder *coder = [[JCKJsonEncoder alloc] init];
            [coder encodeRootObject: value];
            result = [coder encodedJSONObject];
        }
    } else {
        if ([self.transformedValueClass jck_supportDirectDecodingFromJsonValue]) {
            //
            result = [self.transformedValueClass jck_decodeFromJsonValue: value];
            
        } else if ([value isKindOfClass: [NSDictionary class]]) {
            //
            JCKJsonDecoder *coder = [[JCKJsonDecoder alloc] initWithJSONObject: value];
            result = [coder decodeTopLevelObjectOfClass: self.transformedValueClass];
        }
    }
    return result;
}

@end
