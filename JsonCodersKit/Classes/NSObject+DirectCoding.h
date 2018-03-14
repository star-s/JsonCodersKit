//
//  NSObject+DirectCoding.h
//  Pods
//
//  Created by Sergey Starukhin on 14.03.2018.
//

#import <Foundation/Foundation.h>

@protocol JCKDirectJsonDecoding <NSObject>

+ (BOOL)jck_supportDirectDecodingFromJsonValue;

+ (id)jck_decodeFromJsonValue:(id)value;

@end

@protocol JCKDirectJsonEncoding <NSObject>

- (BOOL)jck_supportDirectEncodingToJsonValue;

- (id)jck_encodeToJsonValue;

@end

@interface NSObject (DirectCoding) <JCKDirectJsonDecoding, JCKDirectJsonEncoding>

@end
