//
//  JCKJsonDecoder.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCKJsonDecoder;

NS_ASSUME_NONNULL_BEGIN

@protocol JCKJsonDecoderDelegate <NSObject>

- (nullable id)decoder:(JCKJsonDecoder *)coder convertValue:(nullable id)value toObjectOfClass:(Class)aClass;

@end

@interface JCKJsonDecoder : NSCoder

@property (nonatomic, nullable, weak) id <JCKJsonDecoderDelegate> delegate;

@property (nonatomic, strong, readonly) NSDictionary *JSONObject;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithJSONObject:(NSDictionary *)obj NS_DESIGNATED_INITIALIZER;

- (nullable id)decodeTopLevelObjectOfClass:(Class)aClass;

+ (void)setDecodeNullAsValue:(BOOL)nullValue;

@end

@interface NSObject (DecodingHelper)

@property (class, nullable) id <JCKJsonDecoderDelegate> jck_decodingHelper;

@end

NS_ASSUME_NONNULL_END
