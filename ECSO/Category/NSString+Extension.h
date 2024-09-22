//
//  NSString+Extension.h
//  lexiwed2
//
//  Created by Kyle on 2017/3/22.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(Extension)

-(NSURL *)covertURL;
- (CGFloat)widthWithFont:(UIFont*)font;
- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size;
+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font andMaxSize:(CGSize)size;

+ (NSString*)encodeToBase64String:(UIImage*)image;

- (NSMutableDictionary *)getURLParameters;

+ (BOOL)checkUrlWithString:(NSString *)url;

- (NSString*)sha256;

+ (NSString *)convertToJsonData:(NSDictionary *)dict;

- (NSString *)codingUrl;

- (NSString *)decodeUrl;

- (NSString *)encodeUrl;

- (NSString *)string;
//是否是邮箱
+ (BOOL)isCheckEmail:(NSString *)email;

+ (NSString *)fileSizeWithInterge:(NSInteger)size;

+ (NSMutableAttributedString *)attrHtml:(NSString *)str;

+ (NSString *)removeSpaceAndNewline:(NSString *)str;

/**字典或者数组转化成json串*/
+ (NSString *)transformationToString:(id )transition;

+ (NSString *) md5:(NSString *)str;

+ (NSString *)hmacSHA256WithSecret:(NSString *)secret content:(NSString *)content;

+ (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url;

+ (NSString *)filterHTML:(NSString *)html;

- (NSData *)stringToHexData;
//是否是网址
+ (BOOL)isCheckUrl:(NSString *)url;
//是否是纯数字
+ (BOOL)isCheckNumber:(NSString *)number;

+ (NSString *)tranfater:(NSString *)address;

//判断是否有中文
+ (BOOL)validateContainsChinese:(NSString *)content;
+ (BOOL)containsSpecialCharacter:(NSString *)str;

+ (NSString *)getBundleVersion;

//获取域名
+ (NSString *)getHostUrl:(NSString *)urlString;

@end
