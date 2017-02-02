//
//  NSObject+JsonCompliant.h
//  Pods
//
//  Created by Sergey Starukhin on 02.02.17.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (JsonCompliant)

+ (BOOL)jck_isJsonCompliant;

- (BOOL)jck_isJsonCompliant;

@end
