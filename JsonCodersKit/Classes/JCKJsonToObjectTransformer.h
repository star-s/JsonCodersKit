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
JCKSynthesizeTransformerInterface( resultClass ) \
JCKSynthesizeTransformerImplementation( resultClass ) \

#define JCKSynthesizeTransformerInterface( resultClass ) \
@interface resultClass##Transformer : JCKJsonToObjectTransformer \
@end \

#define JCKSynthesizeTransformerImplementation( resultClass ) \
@implementation resultClass##Transformer \
\
+ (Class)transformedValueClass \
{ \
return [resultClass class]; \
} \
@end \
