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

- (nullable NSString *)decodeStringForKey:(NSString *)key
{
    return [self decodeObjectOfClass: [NSString class] forKey: key];
}

- (nullable NSDate *)decodeDateFromUnixTimeForKey:(NSString *)key
{
    return [NSDate dateWithTimeIntervalSince1970: [self decodeDoubleForKey: key]];
}

- (nullable NSURL *)decodeURLFromStringForKey:(NSString *)key
{
    NSString *url = [self decodeStringForKey: key];
    return url ? [NSURL URLWithString: url] : nil;
}

- (nullable NSUUID *)decodeUUIDFromStringForKey:(NSString *)key
{
    NSString *uuid = [self decodeStringForKey: key];
    return uuid ? [[NSUUID alloc] initWithUUIDString: uuid] : nil;
}

- (void)encodeDateAsUnixTime:(NSDate *)date forKey:(NSString *)key
{
    if (date) {
        [self encodeDouble: date.timeIntervalSince1970 forKey: key];
    }
}

- (void)encodeURLAsString:(NSURL *)url forKey:(NSString *)key
{
    if (url) {
        [self encodeObject: url.absoluteString forKey: key];
    }
}

- (void)encodeUUIDAsString:(NSUUID *)uuid forKey:(NSString *)key
{
    if (uuid) {
        [self encodeObject: uuid.UUIDString forKey: key];
    }
}

@end
