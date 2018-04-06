//
//  JCKVCModel.m
//  JsonCodersKit_Example
//
//  Created by Sergey Starukhin on 06.04.2018.
//  Copyright © 2018 Sergey Starukhin. All rights reserved.
//

#import "JCKVCModel.h"

@implementation JCKVCModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _backgroundColor = [coder decodeObjectOfClass: [UIColor class] forKey: @"bgColor"];
        _guid = [coder decodeObjectOfClass: [NSUUID class] forKey: @"guid"];
        _url = [coder decodeObjectOfClass: [NSURL class] forKey: @"url"];
        _timestamp = [coder decodeObjectOfClass: [NSDate class] forKey: @"timestamp"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject: self.backgroundColor forKey: @"bgColor"];
    [coder encodeObject: self.guid forKey: @"guid"];
    [coder encodeObject: self.url forKey: @"url"];
    [coder encodeObject: self.timestamp forKey: @"timestamp"];
}

@end
