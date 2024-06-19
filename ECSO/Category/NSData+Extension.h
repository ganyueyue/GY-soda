//
//  NSData+Extension.h
//  SXTraining
//
//  Created by YY on 2019/12/23.
//  Copyright © 2019 YY. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Extension)

+ (NSData *)gzipDeflate:(NSString*)str;

+ (NSData *)gzipInflate:(NSData*)data;

+ (NSData *)convertHexStrToData:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
