//
//  AQUserDefaults.h
//  AQFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQSingleton.h"
#import "AQCacheProtocol.h"

@interface AQUserDefaults : NSObject<AQCacheProtocol>

AQ_DEC_SINGLETON

@end

