//
//  Color+HexString.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 06.04.2018.
//  Copyright © 2015 Sergey Starukhin. All rights reserved.
//

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#define JCKColor NSColor
#else
#import <UIKit/UIKit.h>
#define JCKColor UIColor
#endif

@interface JCKColor (HexString)

+ (instancetype)jck_colorWithHexString:(NSString *)hexString;

- (NSString *)jck_hexStringWithAlpha:(BOOL)exportAlpha;

@end
