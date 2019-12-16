//
//  EncDec.h
//  EncryptionObjeC
//
//  Created by Santosh Sangewar on 24/05/16.
//  Copyright © 2016 Arkenea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+AESCrypt.h"

#define Key_EncryptDecrypt   @"6IAVE+56U5t7USZhb+9wCcqrTyJHqAu09j0t6fBngNo"
#define Key_EncryptIV   @"6IAVE+56U5t7USZhb+9wCcqrTyJHqAu09j0t6fBngNo"


@interface EncDec : NSObject

+ (NSData*)AES128Encrypt:(NSString *)cryptString;
+ (NSString*)AES128Base64Encrypt:(NSString *)cryptString;
+ (NSString*)AES128Decrypt:(NSData *)decryptData;
+ (NSString*)AES128Base64Decrypt:(NSString *)decryptData;

@end
