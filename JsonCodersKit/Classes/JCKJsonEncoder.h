//
//  JCKJsonEncoder.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCKJsonEncoder;

@protocol JCKJsonEncoderDelegate <NSObject>

- (id)encoder:(JCKJsonEncoder *)coder encodeJsonObjectFromValue:(id)value;

@end

@interface JCKJsonEncoder : NSCoder

@property (nonatomic, weak) id <JCKJsonEncoderDelegate> delegate;

@property (nonatomic, strong, readonly) NSDictionary *encodedJSONObject;

- (instancetype)initWithMutableDictionary:(NSMutableDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

- (void)encodeRootObject:(id <NSCoding>)rootObject;

+ (void)setEncodeNilValue:(BOOL)encodeNil;

@end

@interface NSObject (EncodingHelper)

@property (class, nullable) id <JCKJsonEncoderDelegate> jck_encodingHelper;

@end
