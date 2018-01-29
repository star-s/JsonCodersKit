//
//  JsonCodersKit.h
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 03.03.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for JsonCodersKit.
FOUNDATION_EXPORT double JsonCodersKitVersionNumber;

//! Project version string for JsonCodersKit.
FOUNDATION_EXPORT const unsigned char JsonCodersKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JsonCodersKit/PublicHeader.h>


#import <JsonCodersKit/CollectionMapping.h>
#import <JsonCodersKit/JCKCompositeTransformer.h>
#import <JsonCodersKit/JCKJsonDecoder.h>
#import <JsonCodersKit/JCKJsonEncoder.h>
#import <JsonCodersKit/JCKJsonToObjectTransformer.h>
#import <JsonCodersKit/JCKObjectToJsonTransformer.h>
#import <JsonCodersKit/NSCoder+JCKAdditions.h>
#import <JsonCodersKit/NSNull+NumericExtension.h>
#import <JsonCodersKit/NSObject+JsonCompliant.h>
