//
//  JCKDirectCodingHelpers.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 06.04.2018.
//

#import <Foundation/Foundation.h>

@interface JCKStringTransformer : NSValueTransformer

- (id)valueFromString:(NSString *)string;
- (NSString *)stringFromValue:(id)value;

@end

FOUNDATION_EXPORT NSValueTransformerName const JCKStringToURLTransformerName;

@interface JCKStringToURLTransformer : JCKStringTransformer
@end

FOUNDATION_EXPORT NSValueTransformerName const JCKStringToUUIDTransformerName;

@interface JCKStringToUUIDTransformer : JCKStringTransformer
@end

FOUNDATION_EXPORT NSValueTransformerName const JCKStringToDateTransformerName;

@interface JCKStringToDateTransformer : JCKStringTransformer

@property (nonatomic, readonly) NSFormatter *formatter;

- (instancetype)initWithFormatter:(NSFormatter *)formatter NS_DESIGNATED_INITIALIZER;

@end

FOUNDATION_EXPORT NSValueTransformerName const JCKStringToDataTransformerName;

@interface JCKStringToDataTransformer : JCKStringTransformer

@property (nonatomic, readonly) NSDataBase64DecodingOptions decodingOptions;
@property (nonatomic, readonly) NSDataBase64EncodingOptions encodingOptions;

- (instancetype)initWithDecodingOptions:(NSDataBase64DecodingOptions)decOpts encodingOptions:(NSDataBase64EncodingOptions)encOpts NS_DESIGNATED_INITIALIZER;

@end

FOUNDATION_EXPORT NSValueTransformerName const JCKStringToColorTransformerName;

@interface JCKStringToColorTransformer : JCKStringTransformer

@property (nonatomic, readonly) BOOL exportAlpha;

- (instancetype)initWithExportAlpha:(BOOL)value NS_DESIGNATED_INITIALIZER;

@end
