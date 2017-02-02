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

- (id)transformedValue:(id)value
{
    id result = nil;
    
    if ([value isKindOfClass: [NSArray class]]) {
        //
        result = [value transformedArray: self];
        
    } else if ([value isKindOfClass: [NSDictionary class]]) {
        //
        JCKJsonDecoder *coder = [[JCKJsonDecoder alloc] initWithJSONObject: value];
        result = [coder decodeTopLevelObjectOfClass: [self.class transformedValueClass]];
        
    } else if ([value isKindOfClass: [self.class transformedValueClass]]) {
        //
        JCKJsonEncoder *coder = [[JCKJsonEncoder alloc] init];
        [coder encodeRootObject: value];
        result = [coder encodedJSONObject];
    }
    return result;
}

@end

@implementation JCKKeyedJsonToObjectTransformer

- (instancetype)initWithKeyPath:(NSString *)keyPath
{
    self = [super init];
    if (self) {
        _keyPath = [keyPath copy];
    }
    return self;
}

- (id)transformedValue:(id)value
{
    NSString *keyPath = self.keyPath;
    
    if (keyPath && [value isKindOfClass: [NSDictionary class]]) {
        //
        id newValue = [value valueForKeyPath: keyPath];
        
        if ([newValue isKindOfClass: [NSDictionary class]] || [newValue isKindOfClass: [NSArray class]]) {
            value = newValue;
        }
    }
    return [super transformedValue: value];
}

@end
