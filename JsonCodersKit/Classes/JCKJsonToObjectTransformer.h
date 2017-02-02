//
//  JCKJsonToObjectTransformer.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCKJsonToObjectTransformer : NSValueTransformer

@end

@interface JCKKeyedJsonToObjectTransformer : JCKJsonToObjectTransformer

@property (nonatomic, copy, readonly) NSString *keyPath;

- (instancetype)initWithKeyPath:(NSString *)keyPath;

@end
