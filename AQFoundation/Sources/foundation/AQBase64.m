//
//  AQBase64.m
//  AQFoundation
//
//  Created by madding.lip on 8/3/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQBase64.h"

static const char *kAQStdBase64Chars =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static const char *kAQUrlSafeBase64Chars =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

void *decodeBase64(const char *inputBuffer, size_t length, size_t *outputLength,
                   char ch63, char ch64);

@implementation AQBase64

+ (NSString *)encodeStandardBase64ForData:(NSData *)iData {
  return [AQBase64 encodeBase64ForData:iData
                                    charList:kAQStdBase64Chars
                                        ch65:'='];
}

+ (NSData *)decodeStandardBase64String:(NSString *)string {
  NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
  size_t outputLength;
  void *outputBuffer =
      decodeBase64([data bytes], [data length], &outputLength, '+', '/');
  NSData *result = [NSData dataWithBytes:outputBuffer length:outputLength];
  free(outputBuffer);
  return result;
}

+ (NSString *)encodeUrlSafeBase64ForData:(NSData *)iData {
  return [AQBase64 encodeBase64ForData:iData
                                    charList:kAQUrlSafeBase64Chars
                                        ch65:' '];
}

+ (NSData *)decodeUrlSafeBase64String:(NSString *)string {
  NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
  size_t outputLength;
  void *outputBuffer =
      decodeBase64([data bytes], [data length], &outputLength, '-', '_');
  NSData *result = [NSData dataWithBytes:outputBuffer length:outputLength];
  free(outputBuffer);
  return result;
}

#pragma - Private Mehtod

+ (NSString *)encodeBase64ForData:(NSData *)iData
                         charList:(const char *)charList
                             ch65:(char)ch65 {
  NSInteger iLen = [iData length];

  NSMutableData *oData = [NSMutableData dataWithLength:((iLen + 2) / 3) * 4];

  uint8_t *input = (uint8_t *)[iData bytes];
  uint8_t *output = (uint8_t *)oData.mutableBytes;

  NSInteger i;
  for (i = 0; i < iLen; i += 3) {
    NSInteger value = 0;
    NSInteger j;
    for (j = i; j < (i + 3); j++) {
      value <<= 8;

      if (j < iLen) {
        value |= (0xFF & input[j]);
      }
    }

    NSInteger index = (i / 3) * 4;
    output[index + 0] = charList[(value >> 18) & 0x3F];
    output[index + 1] = charList[(value >> 12) & 0x3F];
    output[index + 2] = (i + 1) < iLen ? charList[(value >> 6) & 0x3F] : ch65;
    output[index + 3] = (i + 2) < iLen ? charList[(value >> 0) & 0x3F] : ch65;
  }

  NSString *result =
      [[NSString alloc] initWithData:oData encoding:NSASCIIStringEncoding];
  return [result
      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

#define BINARY_UNIT_SIZE 3
#define BASE64_UNIT_SIZE 4

#define padding 65

char lookupBase64(const char ch, char ch63, char ch64) {
  char och = padding;
  if ((ch >= 'A') && (ch <= 'Z')) {
    och = ch - 'A';
  } else if ((ch >= 'a') && (ch <= 'z')) {
    och = ch - 'a' + 26;
  } else if ((ch >= '0') && (ch <= '9')) {
    och = ch - '0' + 52;
  } else if (ch == ch63) {
    och = 62;
  } else if (ch == ch64) {
    och = 63;
  }
  return och;
}

void *decodeBase64(const char *inputBuffer, size_t length, size_t *outputLength,
                   char ch63, char ch64) {
  if (length == -1) {
    length = strlen(inputBuffer);
  }

  size_t outputBufferSize =
      ((length + BASE64_UNIT_SIZE - 1) / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE;
  unsigned char *outputBuffer = (unsigned char *)malloc(outputBufferSize);

  size_t i = 0;
  size_t j = 0;
  while (i < length) {
    unsigned char accumulated[BASE64_UNIT_SIZE];
    size_t accumulateIndex = 0;
    while (i < length) {
      unsigned char decode = lookupBase64(inputBuffer[i++], ch63, ch64);
      if (decode != padding) {
        accumulated[accumulateIndex] = decode;
        accumulateIndex++;

        if (accumulateIndex == BASE64_UNIT_SIZE) {
          break;
        }
      }
    }

    if (accumulateIndex >= 2)
      outputBuffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulateIndex >= 3)
      outputBuffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulateIndex >= 4)
      outputBuffer[j + 2] = (accumulated[2] << 6) | accumulated[3];
    j += accumulateIndex - 1;
  }

  if (outputLength) {
    *outputLength = j;
  }
  return outputBuffer;
}
