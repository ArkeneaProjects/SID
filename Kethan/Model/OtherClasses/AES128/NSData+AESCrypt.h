//
//  NSData+AESCrypt.h
//
//  AES128Encryption + Base64Encoding
//

#import <Foundation/Foundation.h>

@interface NSData (AESCrypt)


- (NSString *)base64Encoding;
- (NSData *)AES128EncryptedDataWithKey:(NSString *)key;



- (NSData *)AES128DecryptedDataWithKey:(NSString *)key;



- (NSData *)AES128EncryptedDataWithKey:(NSString *)key iv:(NSString *)iv;



- (NSData *)AES128DecryptedDataWithKey:(NSString *)key iv:(NSString *)iv;
@end
