//
//  NSCoder+DecodeArray.h
//  Pods
//
//  Created by Sergey Starukhin on 02.02.17.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCoder (DecodeArray)

- (nullable NSArray *)decodeArrayObjectsOfClass:(Class)aClass forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
