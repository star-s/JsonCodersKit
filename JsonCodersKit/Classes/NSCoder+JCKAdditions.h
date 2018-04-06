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

@end

@interface NSCoder (JCKAdditions_deprecated)

- (nullable NSString *)decodeStringForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Don't use this method");
- (nullable NSURL *)decodeURLForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Don't use this method");
- (nullable NSUUID *)decodeUUIDForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Don't use this method");

- (nullable NSDate *)decodeDateFromUnixTimeForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Don't use this method");

- (void)encodeDateAsUnixTime:(NSDate *)date forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Don't use this method");

@end

NS_ASSUME_NONNULL_END
