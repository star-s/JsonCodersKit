//
//  JCKDefaultDecodingHelper.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 21.05.2018.
//

#import <JsonCodersKit/JCKJsonDecoder.h>

@interface JCKDefaultDecodingHelper : NSObject <JCKJsonDecoderDelegate>

#pragma mark - UUID

- (NSUUID *)decodeUUIDFromString:(NSString *)value;

#pragma mark - URL

- (NSURL *)decodeURLFromString:(NSString *)value;

#pragma mark - Data

@property (nonatomic, readonly) NSDataBase64DecodingOptions decodingOptions;

- (NSData *)decodeDataFromString:(NSString *)value;

#pragma mark - Date

@property (nonatomic, readonly) NSFormatter *formatter;

- (NSDate *)decodeDateFromString:(NSString *)value;

- (NSDate *)decodeDateFromNumber:(NSNumber *)value;

#pragma mark - String

- (NSString *)decodeStringFromNumber:(NSNumber *)value;

#pragma mark - Color

- (id)decodeColorFromString:(NSString *)value;

- (id)decodeColorFromNumber:(NSNumber *)value;

@end
