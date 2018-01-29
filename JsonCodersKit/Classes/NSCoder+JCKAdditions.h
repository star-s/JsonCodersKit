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
- (nullable NSURL *)decodeURLForKey:(NSString *)key;
- (nullable NSUUID *)decodeUUIDForKey:(NSString *)key;

- (nullable NSDate *)decodeDateFromUnixTimeForKey:(NSString *)key;

- (void)encodeDateAsUnixTime:(NSDate *)date forKey:(NSString *)key;

- (BOOL)containsNotNullValueForKey:(NSString *)key;

@end

@interface NSCoder (JCKAdditions_deprecated)

- (nullable NSURL *)decodeURLFromStringForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Don't use this method");
- (nullable NSUUID *)decodeUUIDFromStringForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Don't use this method");

- (void)encodeURLAsString:(NSURL *)url forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Don't use this method");
- (void)encodeUUIDAsString:(NSUUID *)uuid forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Don't use this method");

@end

NS_ASSUME_NONNULL_END
