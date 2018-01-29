//
//  NSNull+NumericExtension.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 29.01.18.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import "NSNull+NumericExtension.h"

@implementation NSNull (NumericExtension)

- (double)doubleValue
{
    return 0.0;
}

- (float)floatValue
{
    return 0.0f;
}

- (int)intValue
{
    return 0;
}

- (NSInteger)integerValue
{
    return 0;
}

- (long long)longLongValue
{
    return 0;
}

- (BOOL)boolValue
{
    return NO;
}

@end
