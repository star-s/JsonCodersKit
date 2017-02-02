//
//  CollectionMapping.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "CollectionMapping.h"

@implementation JCKBlockTransformer {
    id __nullable(^transformator)(id __nullable anObject);
}

+ (Class)transformedValueClass
{
    return [NSObject class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

+ (instancetype)transformerWithBlock:(id __nullable(^)(id __nullable anObject))block
{
    return [[self alloc] initWithBlock: block];
}

- (instancetype)initWithBlock:(id __nullable(^)(id __nullable anObject))block
{
    NSParameterAssert(block != nil);
    self = [super init];
    if (self) {
        transformator = [block copy];
    }
    return self;
}

- (nullable id)transformedValue:(nullable id)value
{
    return transformator(value);
}

@end

@implementation NSArray (CollectionMapping)

- (NSArray *)transformedArray:(NSValueTransformer *)transformer
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity: self.count];
    
    for (id object in self) {
        id transformedObject = [transformer transformedValue: object];
        if (transformedObject) {
            [result addObject: transformedObject];
        }
    }
    return [result copy];
}

- (NSArray *)mapWithBlock:(id __nullable(^)(id anObject))block
{
    return [self transformedArray: [JCKBlockTransformer transformerWithBlock: block]];
}

@end

@implementation NSMutableArray (CollectionMapping)

- (void)transformInPlace:(NSValueTransformer *)transformer
{
    [self enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        id transformedObject = [transformer transformedValue: obj];
        if (transformedObject) {
            [self replaceObjectAtIndex: idx withObject: transformedObject];
        }
    }];
}

- (void)mapInPlaceWithBlock:(id __nullable(^)(id anObject))block
{
    [self transformInPlace: [JCKBlockTransformer transformerWithBlock: block]];
}

@end

@implementation NSOrderedSet (CollectionMapping)

- (NSOrderedSet *)transformedOrderedSet:(NSValueTransformer *)transformer
{
    NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSetWithCapacity: self.count];
    
    for (id object in self) {
        id transformedObject = [transformer transformedValue: object];
        if (transformedObject) {
            [result addObject: transformedObject];
        }
    }
    return [result copy];
}

- (NSOrderedSet *)mapWithBlock:(id __nullable(^)(id anObject))block
{
    return [self transformedOrderedSet: [JCKBlockTransformer transformerWithBlock: block]];
}

@end

@implementation NSMutableOrderedSet (CollectionMapping)

- (void)transformInPlace:(NSValueTransformer *)transformer
{
    [self enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        id transformedObject = [transformer transformedValue: obj];
        if (transformedObject) {
            [self replaceObjectAtIndex: idx withObject: transformedObject];
        }
    }];
}

- (void)mapInPlaceWithBlock:(id __nullable(^)(id anObject))block
{
    [self transformInPlace: [JCKBlockTransformer transformerWithBlock: block]];
}

@end

@implementation NSSet (CollectionMapping)

- (NSSet *)transformedSet:(NSValueTransformer *)transformer
{
    NSMutableSet *result = [NSMutableSet setWithCapacity: self.count];
    
    for (id object in self) {
        id transformedObject = [transformer transformedValue: object];
        if (transformedObject) {
            [result addObject: transformedObject];
        }
    }
    return [result copy];
}

- (NSSet *)mapWithBlock:(id __nullable(^)(id anObject))block
{
    return [self transformedSet: [JCKBlockTransformer transformerWithBlock: block]];
}

@end
