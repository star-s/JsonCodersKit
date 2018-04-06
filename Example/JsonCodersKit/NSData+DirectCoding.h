//
//  NSData+DirectCoding.h
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 06.04.2018.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JsonCodersKit/JsonCodersKit.h>

@interface NSData (DirectCoding)  <JCKDirectJsonDecoding, JCKDirectJsonEncoding>

+ (void)setJsonDecodingOptions:(NSDataBase64DecodingOptions)opts;

+ (void)setJsonEncodingOptions:(NSDataBase64EncodingOptions)opts;

@end
