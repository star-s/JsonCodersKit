//
//  JCKDirectCodingHelpers.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 06.04.2018.
//

#import <Foundation/Foundation.h>

#pragma mark - JSON values without coding

extern NSValueTransformerName const JCKStringFromJsonTransformerName;

@interface JCKStringFromJsonTransformer : NSValueTransformer
@end

extern NSValueTransformerName const JCKNullFromJsonTransformerName;

@interface JCKNullFromJsonTransformer : NSValueTransformer
@end

extern NSValueTransformerName const JCKNumberFromJsonTransformerName;

@interface JCKNumberFromJsonTransformer : NSValueTransformer
@end

extern NSValueTransformerName const JCKDictionaryFromJsonTransformerName;

@interface JCKDictionaryFromJsonTransformer : NSValueTransformer
@end

extern NSValueTransformerName const JCKArrayFromJsonTransformerName;

@interface JCKArrayFromJsonTransformer : NSValueTransformer
@end

#pragma mark - JSON values with coding

extern NSValueTransformerName const JCKURLFromJsonTransformerName;

@interface JCKURLFromJsonTransformer : NSValueTransformer
@end

extern NSValueTransformerName const JCKUUIDFromJsonTransformerName;

@interface JCKUUIDFromJsonTransformer : NSValueTransformer

@property (nonatomic, readonly) BOOL convertToLowercaseString;

- (instancetype)initWithConversionToLowercaseString:(BOOL)convert;

@end

extern NSValueTransformerName const JCKDateFromJsonTransformerName;

@interface JCKDateFromJsonTransformer : NSValueTransformer

@property (nonatomic, readonly) NSFormatter *formatter;

- (instancetype)initWithFormatter:(NSFormatter *)formatter;

@end

extern NSValueTransformerName const JCKUnixDateFromJsonTransformerName;

@interface JCKUnixDateFromJsonTransformer : NSValueTransformer
@end

extern NSValueTransformerName const JCKDataFromJsonTransformerName;

@interface JCKDataFromJsonTransformer : NSValueTransformer

@property (nonatomic, readonly) NSDataBase64DecodingOptions decodingOptions;
@property (nonatomic, readonly) NSDataBase64EncodingOptions encodingOptions;

- (instancetype)initWithDecodingOptions:(NSDataBase64DecodingOptions)decOpts encodingOptions:(NSDataBase64EncodingOptions)encOpts;

@end

extern NSValueTransformerName const JCKColorFromJsonTransformerName;

@interface JCKColorFromJsonTransformer : NSValueTransformer

@property (nonatomic, readonly) BOOL exportAlpha;

- (instancetype)initWithExportAlpha:(BOOL)value;

@end
