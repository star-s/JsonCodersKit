//
//  JCKObjectToJsonTransformer.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "JCKObjectToJsonTransformer.h"
#import "JCKJsonEncoder.h"
#import "CollectionMapping.h"
#import "NSObject+DirectCoding.h"

NSValueTransformerName const JCKObjectToJsonTransformerName = @"JCKObjectToJsonTransformer";

@implementation JCKObjectToJsonTransformer

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    id result = nil;
    
    if ([value jck_supportDirectEncodingToJsonValue]) {
        //
        result = [value jck_encodeToJsonValue];
        
    } else if ([value isKindOfClass: [NSArray class]]) {
        //
        result = [value transformedArray: self];

    } else if ([value conformsToProtocol: @protocol(NSCoding)]) {
        //
        JCKJsonEncoder *coder = [[JCKJsonEncoder alloc] init];
        [coder encodeRootObject: value];
        result = coder.encodedJSONObject;
    }
    return result;
}

@end
