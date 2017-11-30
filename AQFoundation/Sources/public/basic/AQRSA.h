//
//  AQRSA.h
//  AQDevice
//
//  Created by madding.lip on 8/10/15.
//  //  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQRSA : NSObject

+ (NSString *)encryptRSA:(NSString *)plainText
            publicKeyRef:(SecKeyRef)publicKeyRef;

@end
