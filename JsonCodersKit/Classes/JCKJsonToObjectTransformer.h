//
//  JCKJsonToObjectTransformer.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCKJsonToObjectTransformer : NSValueTransformer

@property (nonatomic, readonly) Class transformedValueClass;

- (instancetype)initWithTransformedValueClass:(Class)aClass;

@end

#define JCKStringize_helper(x) #x
#define JCKStringize(x) @JCKStringize_helper(x)

#define JCKSynthesizeTransformer( resultClass ) \
JCKSynthesizeTransformerInterface( resultClass ) \
JCKSynthesizeTransformerImplementation( resultClass ) \

#define JCKSynthesizeTransformerInterface( resultClass ) \
\
FOUNDATION_EXPORT NSValueTransformerName const resultClass##TransformerName;\
\
@interface resultClass##Transformer : JCKJsonToObjectTransformer \
@end \

#define JCKSynthesizeTransformerImplementation( resultClass ) \
\
NSValueTransformerName const resultClass##TransformerName = JCKStringize(resultClass##Transformer);\
\
@implementation resultClass##Transformer \
\
+ (Class)transformedValueClass \
{ \
return [resultClass class]; \
} \
@end \
