//
//  JCKCompoundTransformer.h
//  Pods
//
//  Created by Sergey Starukhin on 02.03.17.
//
//

#import <Foundation/Foundation.h>

@interface JCKCompoundTransformer : NSValueTransformer

@property (nullable, readonly, copy) NSString *key;
@property (nullable, readonly, copy) NSArray *subtransformers;

- (nonnull instancetype)initWithKey:(nullable NSString *)key subtransformers:(nullable NSArray <NSValueTransformer *> *)subtransformers NS_DESIGNATED_INITIALIZER;

@end

@interface NSValueTransformer (TransformValueProperty)

+ (nonnull NSValueTransformer *)valueTransformerWithKey:(nullable NSString *)key;

@end
