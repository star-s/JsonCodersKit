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

@interface NSObject (JCKJsonEncoderPrivate)

@property (nonatomic, strong, readonly) NSArray <Class> *jck_classHierarchy;
/*
 Return transformer that can convert a JSON value to a value of the same class as instance
 searching in transformers registered with method [JCKJsonDecoder +setValueTransformerOrHisName:forClass:]
 */
@property (nonatomic, nullable, readonly) NSValueTransformer *jck_jsonValueTransformer;

@end

NS_ASSUME_NONNULL_END
