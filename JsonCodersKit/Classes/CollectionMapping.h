//
//  CollectionMapping.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCKBlockTransformer : NSValueTransformer

+ (instancetype)transformerWithBlock:(id __nullable(^)(id __nullable anObject))block;

@end

@interface NSArray (CollectionMapping)

- (NSArray *)transformedArray:(NSValueTransformer *)transformer;

- (NSArray *)mapWithBlock:(id __nullable(^)(id anObject))block;

@end

@interface NSMutableArray (CollectionMapping)

- (void)transformInPlace:(NSValueTransformer *)transformer;

- (void)mapInPlaceWithBlock:(id __nullable(^)(id anObject))block;

@end

@interface NSOrderedSet (CollectionMapping)

- (NSOrderedSet *)transformedOrderedSet:(NSValueTransformer *)transformer;

- (NSOrderedSet *)mapWithBlock:(id __nullable(^)(id anObject))block;

@end

@interface NSMutableOrderedSet (CollectionMapping)

- (void)transformInPlace:(NSValueTransformer *)transformer;

- (void)mapInPlaceWithBlock:(id __nullable(^)(id anObject))block;

@end

@interface NSSet (CollectionMapping)

- (NSSet *)transformedSet:(NSValueTransformer *)transformer;

- (NSSet *)mapWithBlock:(id __nullable(^)(id anObject))block;

@end

NS_ASSUME_NONNULL_END
