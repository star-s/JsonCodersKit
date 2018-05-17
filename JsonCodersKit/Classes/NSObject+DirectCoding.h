//
//  NSObject+DirectCoding.h
//  Pods
//
//  Created by Sergey Starukhin on 14.03.2018.
//

#import <Foundation/Foundation.h>

@interface NSObject (DirectCoding)

@property (class, nullable) NSValueTransformer *jck_directCodingHelper DEPRECATED_MSG_ATTRIBUTE("Don't use this");

- (BOOL)jck_isValidJSONObject;

@end
