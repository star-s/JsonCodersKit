//
//  NSData+HexString.h
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 06.04.2018.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HexString)

+ (NSData *)dataWithHexString:(NSString *)hexString;

- (NSString *)hexString;

@end
