//
//  JCKJsonEncoder.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCKJsonEncoder : NSCoder

@property (nonatomic, strong, readonly) NSDictionary *encodedJSONObject;

- (instancetype)initWithMutableDictionary:(NSMutableDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

- (void)encodeRootObject:(id <NSCoding>)rootObject;

+ (void)setEncodeNilValue:(BOOL)encodeNil;

@end

@interface JCKJsonEncoder (Transformers)

//+ (void)setTransformer:(nullable id)transformerOrName forClass:(Class)aClass;

+ (nullable NSValueTransformer *)transformerForClass:(Class)aClass;

+ (nullable NSValueTransformer *)reversedTransformerForClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
