//
//  JCKJsonDecoder.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCKJsonDecoder : NSCoder

@property (nonatomic, strong, readonly) NSDictionary *JSONObject;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithJSONObject:(NSDictionary *)obj NS_DESIGNATED_INITIALIZER;

- (nullable id)decodeTopLevelObjectOfClass:(Class)aClass;

+ (void)setDecodeNullAsValue:(BOOL)nullValue;

@end

@interface JCKJsonDecoder (Transformers)

+ (void)setTransformer:(nullable id)transformerOrName forClass:(Class)aClass;

+ (nullable NSValueTransformer *)transformerForClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
