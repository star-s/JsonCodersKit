//
//  NSCoder+JCKAdditions.m
//  Pods
//
//  Created by Sergey Starukhin on 02.02.17.
//
//

#import "NSCoder+JCKAdditions.h"

@implementation NSCoder (JCKAdditions)

- (NSArray *)decodeArrayObjectsOfClass:(Class)aClass forKey:(NSString *)key
{
    NSArray *result = [self decodeObjectForKey: key];
    
    if ([result isKindOfClass: [NSArray class]]) {
        //
        __block BOOL isAllObjectsOk = YES;
        
        [result enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            isAllObjectsOk = [obj isKindOfClass: aClass];
            *stop = !isAllObjectsOk;
        }];
        result = isAllObjectsOk ? result : nil;
    } else {
        result = nil;
    }
    return result;
}

@end

@implementation NSCoder (JCKAdditions_deprecated)

- (nullable NSString *)decodeStringForKey:(NSString *)key
{
    return [self decodeObjectOfClass: [NSString class] forKey: key];
}

- (nullable NSURL *)decodeURLForKey:(NSString *)key
{
    return [self decodeObjectOfClass: [NSURL class] forKey: key];
}

- (nullable NSUUID *)decodeUUIDForKey:(NSString *)key
{
    return [self decodeObjectOfClass: [NSUUID class] forKey: key];
}

- (nullable NSDate *)decodeDateFromUnixTimeForKey:(NSString *)key
{
    if ([self containsValueForKey: key]) {
        return [NSDate dateWithTimeIntervalSince1970: [self decodeDoubleForKey: key]];
    }
    return nil;
}

- (void)encodeDateAsUnixTime:(NSDate *)date forKey:(NSString *)key
{
    if (date) {
        [self encodeDouble: date.timeIntervalSince1970 forKey: key];
    }
}

@end
