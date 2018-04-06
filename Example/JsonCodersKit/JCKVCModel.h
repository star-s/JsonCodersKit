//
//  JCKVCModel.h
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 06.04.2018.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCKVCModel : NSObject <NSCoding>

@property (nonatomic, strong, readonly) UIColor *backgroundColor;
@property (nonatomic, strong, readonly) NSUUID *guid;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSDate *timestamp;

@end
