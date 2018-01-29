//
//  NSNull+NumericExtension.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 29.01.18.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (NumericExtension)

@property (readonly) double doubleValue;
@property (readonly) float floatValue;
@property (readonly) int intValue;
@property (readonly) NSInteger integerValue;
@property (readonly) long long longLongValue;
@property (readonly) BOOL boolValue;

@end
