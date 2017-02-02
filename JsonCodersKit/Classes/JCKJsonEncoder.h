//
//  JCKJsonEncoder.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCKJsonEncoder : NSCoder

@property (nonatomic, strong, readonly) NSDictionary *encodedJSONObject;

- (instancetype)initWithMutableDictionary:(NSMutableDictionary *)dictionary;

- (void)encodeRootObject:(id <NSCoding>)rootObject;

@end
