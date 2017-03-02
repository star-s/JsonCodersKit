//
//  JCKJsonToObjectTransformer.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCKJsonToObjectTransformer : NSValueTransformer

@end

#define JCKSynthesizeTransformer( resultClass ) \
@interface resultClass##Transformer : JCKJsonToObjectTransformer \
@end \
\
@implementation resultClass##Transformer \
\
+ (Class)transformedValueClass \
{ \
return [resultClass class]; \
} \
@end \
