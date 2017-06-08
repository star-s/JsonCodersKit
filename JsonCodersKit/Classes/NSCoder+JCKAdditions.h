//
//  NSCoder+JCKAdditions.h
//  Pods
//
//  Created by Sergey Starukhin on 02.02.17.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCoder (JCKAdditions)

- (nullable NSArray *)decodeArrayObjectsOfClass:(Class)aClass forKey:(NSString *)key;

- (nullable NSString *)decodeStringForKey:(NSString *)key;
- (nullable NSDate *)decodeDateFromUnixTimeForKey:(NSString *)key;
- (nullable NSURL *)decodeURLFromStringForKey:(NSString *)key;
- (nullable NSUUID *)decodeUUIDFromStringForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
