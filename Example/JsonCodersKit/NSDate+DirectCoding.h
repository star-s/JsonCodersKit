//
//  NSDate+DirectCoding.h
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 20.03.2018.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JsonCodersKit/JsonCodersKit.h>

@interface NSDate (DirectCoding) <JCKDirectJsonDecoding, JCKDirectJsonEncoding>

+ (void)setJsonCodingFormatter:(NSFormatter *)formatter;

@end
