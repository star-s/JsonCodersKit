//
//  JCKDefaultEncodingHelper.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 21.05.2018.
//

#import <JsonCodersKit/JCKJsonEncoder.h>

@interface JCKDefaultEncodingHelper : NSObject <JCKJsonEncoderDelegate>

@property (nonatomic, readonly, getter=isEncodeNilAsNull) BOOL encodeNilAsNull;

- (instancetype)initWithEncodeNilAsNull:(BOOL)encode;

#pragma mark - UUID

- (NSString *)encodeUUID:(NSUUID *)value;

#pragma mark - NSURL

- (NSString *)encodeURL:(NSURL *)value;

#pragma mark - Data

@property (nonatomic, readonly) NSDataBase64EncodingOptions encodingOptions;

- (id)encodeData:(NSData *)value;

#pragma mark - Date

@property (nonatomic, readonly) NSFormatter *formatter;

- (id)encodeDate:(NSDate *)value;

#pragma mark - Color

@property (nonatomic, readonly) BOOL exportAlpha;

- (id)encodeColor:(id)value;

@end
