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

NSValueTransformerName const JCKObjectToJsonTransformerName = @"JCKObjectToJsonTransformer";

@implementation JCKObjectToJsonTransformer

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if ([value isKindOfClass: [NSArray class]]) {
        return [value transformedArray: self];
    } else {
        id result = nil;
        
        NSValueTransformer *helper = [value jck_jsonValueTransformer];
        if (helper) {
            result = [helper reverseTransformedValue: value];
        } else if ([value conformsToProtocol: @protocol(NSCoding)]) {
            JCKJsonEncoder *coder = [[JCKJsonEncoder alloc] init];
            [coder encodeRootObject: value];
            result = coder.encodedJSONObject;
        }
        return result;
    }
}

@end
