//
//  AQDate.m
//  AQFoundation
//
//  Created by madding.lip on 8/11/15.
//  //  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQDate.h"

@implementation AQDate

+ (NSNumber *)currentTimeStampInMillSeconds {
  NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]);
  long long digits = (long long)time;
  int decimalDigits = (int)(fmod(time, 1) * 1000);
  long long timestamp = (digits * 1000) + decimalDigits;
  return [[NSNumber alloc] initWithLongLong:timestamp];
}

+ (NSNumber *)currentTimeStampInSeconds {
  NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]);
  return [[NSNumber alloc] initWithLongLong:(long long)time];
}

+ (NSString *)getDefaultForamtDate {
  NSDate *date = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
  [dateFormatter
      setDateStyle:NSDateFormatterMediumStyle];  // Set date and time styles
  [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
  NSString *dateString = [dateFormatter stringFromDate:date];
  return dateString;
}

@end
