//
//  UIColor+HexString.h
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 09.12.15.
//  Copyright © 2015 Sergey Starukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (void)addAlphaToHexStringByDefault:(BOOL)value;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

- (NSString *)hexString;

- (NSString *)hexStringWithAlpha:(BOOL)exportAlpha;

@end
