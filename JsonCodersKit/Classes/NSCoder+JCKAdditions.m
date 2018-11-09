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
