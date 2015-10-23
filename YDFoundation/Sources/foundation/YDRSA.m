//
//  YDRSA.m
//  YDDevice
//
//  Created by madding.lip on 8/10/15.
//  //  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDRSA.h"

#import "YDBase64.h"

@implementation YDRSA

/**
 *  非对称性加密
 *  参考: https://github.com/reejosamuel/RSA/blob/master/RSA/RSA.m
 *
 */
+ (NSString *)encryptRSA:(NSString *)plainText
            publicKeyRef:(SecKeyRef)publicKeyRef {
  NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
  // 计算buffer大小
  size_t cipherBufferSize = SecKeyGetBlockSize(publicKeyRef);
  uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
  memset((void *)cipherBuffer, 0 * 0, cipherBufferSize);
  //    uint8_t *nonce = (uint8_t *)[plainTextData bytes];

  size_t blockSize = cipherBufferSize - 11;
  size_t blockCount = (size_t)ceil([plainTextData length] / (double)blockSize);
  NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];

  for (int i = 0; i < blockCount; i++) {
    int bufferSize =
        (int)MIN(blockSize, [plainTextData length] - i * blockSize);
    NSData *buffer =
        [plainTextData subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];

    OSStatus status = SecKeyEncrypt(
        publicKeyRef, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes],
        [buffer length], cipherBuffer, &cipherBufferSize);

    if (status == noErr) {
      NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer
                                              length:cipherBufferSize];
      [encryptedData appendData:encryptedBytes];
    } else {
      if (cipherBuffer) {
        free(cipherBuffer);
      }
      return nil;
    }
  }
  if (cipherBuffer) free(cipherBuffer);

  return [YDBase64 encodeUrlSafeBase64ForData:encryptedData];
}

@end
