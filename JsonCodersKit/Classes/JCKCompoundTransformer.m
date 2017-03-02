//
//  JCKCompoundTransformer.m
//  Pods
//
//  Created by Sergey Starukhin on 02.03.17.
//
//

#import "JCKCompoundTransformer.h"

@implementation NSValueTransformer (TransformValueProperty)

+ (NSValueTransformer *)valueTransformerWithKey:(NSString *)key
{
    NSValueTransformer *realTransformer = [[self alloc] init];
    return [[JCKCompoundTransformer alloc] initWithKey: key subtransformers: realTransformer ? @[realTransformer] : nil];
}

@end

@implementation JCKCompoundTransformer

- (instancetype)init
{
    return [self initWithKey: nil subtransformers: nil];
}

- (instancetype)initWithKey:(NSString *)key subtransformers:(NSArray<NSValueTransformer *> *)subtransformers
{
    self = [super init];
    if (self) {
        _key = [key copy];
        _subtransformers = [subtransformers copy];
    }
    return self;
}

- (id)transformedValue:(id)value
{
    if (self.key) {
        //
        id newValue = nil;
        
        @try {
            newValue = [value valueForKeyPath: self.key];
        } @catch (NSException *exception) {
            newValue = nil;
#if DEBUG
            NSLog(@"%s - %@", __PRETTY_FUNCTION__, exception);
#endif
        } @finally {
            value = newValue;
        }
    }
    for (NSValueTransformer *transformer in self.subtransformers) {
        value = [transformer transformedValue: value];
    }
    return value;
}

@end
