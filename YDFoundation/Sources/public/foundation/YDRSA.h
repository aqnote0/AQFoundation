//
//  YDRSA.h
//  YDDevice
//
//  Created by madding.lip on 8/10/15.
//  //  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDRSA : NSObject

+ (NSString *)encryptRSA:(NSString *)plainText
            publicKeyRef:(SecKeyRef)publicKeyRef;

@end
