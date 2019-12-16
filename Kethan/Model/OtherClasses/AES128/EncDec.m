//
//  EncDec.m
//  EncryptionObjeC
//
//  Created by Santosh Sangewar on 24/05/16.
//  Copyright © 2016 Arkenea. All rights reserved.
//

#import "EncDec.h"

@interface EncDec ()

@end

@implementation EncDec



+ (NSData*)AES128Encrypt:(NSString *)cryptString {
    
    NSData *encryptData  = nil;
    encryptData = [[cryptString dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptedDataWithKey:Key_EncryptDecrypt iv:Key_EncryptDecrypt];
    NSLog(@"Encrypt AES128: %@", encryptData);
    
    return  encryptData;
}



+ (NSString*)AES128Base64Encrypt:(NSString *)cryptString {
    
    NSData *encryptData  = [EncDec AES128Encrypt:cryptString];
    NSString *base64EncryptText = [encryptData base64EncodedStringWithOptions:0];
    NSLog(@"Encrypt AES128+base64: %@", base64EncryptText);
    
    return  base64EncryptText;
}



+ (NSString*)AES128Decrypt:(NSData *)decryptData {
    
    NSString *decryptString  = nil;
    decryptString  = [[NSString alloc] initWithData:[decryptData AES128DecryptedDataWithKey:Key_EncryptDecrypt iv:Key_EncryptDecrypt]
                                       encoding:NSUTF8StringEncoding];
    NSLog(@"decrypt AES128: %@",decryptString);
    
    return  decryptString;
}



+ (NSString*)AES128Base64Decrypt:(NSString *)decryptData {
    
    NSData* cipherData = [[NSData alloc] initWithBase64EncodedString:decryptData
                                                options:0];
    NSString* plainText  = [[NSString alloc] initWithData:[cipherData AES128DecryptedDataWithKey:Key_EncryptDecrypt iv:Key_EncryptDecrypt]
                                       encoding:NSUTF8StringEncoding];
    NSLog(@"decrypt AES128+base64: %@", plainText);
    
    return  plainText;
}




@end
