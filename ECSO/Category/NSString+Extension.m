//
//  NSString+Extension.m
//  lexiwed2
//
//  Created by Kyle on 2017/3/22.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
@implementation NSString(Extension)

//md5 encode
+(NSString *) md5:(NSString *)str
{
    if (str.length <= 0) {
        return @"";
    }
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output.lowercaseString;
}

+ (NSString *)encodeToBase64String:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    NSString *str =  [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    return [NSString removeSpaceAndNewline:str];

}

+ (NSString *)removeSpaceAndNewline:(NSString *)str{
   
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

+ (BOOL)checkUrlWithString:(NSString *)url {
    if(url.length < 1 || ([url containsString:@"】"] &&  [url containsString:@"「"]))
        return NO;
    if (url.length > 4 && ([[url substringToIndex:4] isEqualToString:@"www."])) {
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    
    if ((![url hasPrefix:@"http"]) && ([url containsString:@"."])) {
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
        NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL result = [urlTest evaluateWithObject:url];
    return result;
}

//是否是网址
+ (BOOL)isCheckUrl:(NSString *)url {
//    NSString *regex =@"((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?";
    NSString *regex = @"^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL result = [urlTest evaluateWithObject:url];
    return result;
}

//获取域名
+ (NSString *)getHostUrl:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *domain = [url host];
    if (domain.length <= 0) {
        domain = urlString;
    }
    return domain;
}

//是否是纯数字
+ (BOOL)isCheckNumber:(NSString *)number {
    NSString *regex =@"^[0-9]*$";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:number];
}

//是否是邮箱
+ (BOOL)isCheckEmail:(NSString *)email {
    NSString *regex =@"\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:email];
}

-(NSURL *)covertURL{
    NSURL *url = [NSURL URLWithString:self];
    if (url != nil){
        return url;
    }
    
    return [NSURL URLWithString:@""];
}


-(CGFloat)widthWithFont:(UIFont*)font {
    if (font == nil) {
        font = [UIFont systemFontOfSize:13];
    }
    //特殊的格式要求都写在属性字典中
    NSDictionary*attrs =@{NSFontAttributeName: font};
    //返回一个矩形，大小等于文本绘制完占据的宽和高。
    return  [self  boundingRectWithSize:CGSizeMake(1000, 1000)  options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs   context:nil].size.width;
}


- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size {
    //特殊的格式要求都写在属性字典中
    NSDictionary*attrs =@{NSFontAttributeName: font};
    //返回一个矩形，大小等于文本绘制完占据的宽和高。
    return  [self  boundingRectWithSize:size  options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs   context:nil].size;
}

+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font andMaxSize:(CGSize)size{
    NSDictionary*attrs =@{NSFontAttributeName: font};
    return  [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs  context:nil].size;
}

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters {
    
    // 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

- (NSString*)sha256
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];

    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    CC_LONG length = (CC_LONG)data.length;

    CC_SHA256(data.bytes, length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}


+ (NSString *)hmacSHA256WithSecret:(NSString *)secret content:(NSString *)content {
    const char *cKey  = [secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [content cStringUsingEncoding:NSUTF8StringEncoding];// 有可能有中文 所以用NSUTF8StringEncoding -> NSASCIIStringEncoding
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

//计算出大小
+ (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

- (NSString *)codingUrl {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)decodeUrl {
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)encodeUrl {
    NSString *urlStr = [self stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet]];
    return urlStr;
}


- (NSString *)string {
    NSString *laguageType = @"zh-Hans";
    NSInteger lang = [STUserDefault integerValueForKey:@"STLanguage"];
    if (lang == 0) {
        NSString *language = [NSLocale preferredLanguages][0];
        if ([language.lowercaseString hasPrefix:@"zh"]) {
            laguageType = @"zh-Hans";
        } else if ([language.lowercaseString hasPrefix:@"ja"]) {
            laguageType = @"ja";
        } else if ([language.lowercaseString hasPrefix:@"ko"]) {
            laguageType = @"ko";
        } else {
            laguageType = @"en";
        }
    } else if (lang == 1) {
        laguageType = @"zh-Hans";
    } else if (lang == 3) {
        laguageType = @"ja";
    } else if (lang == 4) {
        laguageType = @"ko";
    } else {
        laguageType = @"en";
    }
    NSString *languePath = [[NSBundle mainBundle] pathForResource:laguageType ofType:@"lproj"];
    NSString *text = [[NSBundle bundleWithPath:languePath] localizedStringForKey:self value:nil table:@"String"];
    return text;
}

/**字典或者数组转化成json串*/
+ (NSString *)transformationToString:(id )transition {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:transition
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error != nil) {
        NSLog(@"%@",error);
        return @"转化格式报错了";
    }
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return @"转化失败";
    } else {
        
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        NSRange range2 = {0,mutStr.length};
        //去掉字符串中的换行符
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        NSRange range = {0,mutStr.length};
        //去掉字符串中的空格
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        return mutStr;
    }
}


+ (NSString *)filterHTML:(NSString *)html
{
    if (html.length <= 0) {
        return @"";
    }
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

+ (NSMutableAttributedString *)attrHtml:(NSString *)str {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

- (NSData *)stringToHexData
{
    int len = (int) self.length / 2;    // Target length
    unsigned char *buf = (unsigned char *)malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};

    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }

    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}

+ (NSString *)tranfater:(NSString *)address {
    if (address.length > 20) {
        return [NSString stringWithFormat:@"%@...%@",[address substringToIndex:12] , [address substringFromIndex:address.length - 6]];
    }
    return address;
}


//判断是否有中文

+ (BOOL)validateContainsChinese:(NSString *)content {

// ^[\u4e00-\u9fa5] 以中文开头 的字符串
// [\u4e00-\u9fa5] 包含中文

    NSRegularExpression *regularexpression = [[NSRegularExpression alloc] initWithPattern:@"[\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:nil];

    return ([regularexpression numberOfMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length)] > 0);

}


+ (BOOL)containsSpecialCharacter:(NSString *)str{
    NSString *specialCharacters = @"~`!！。，、？@#$%^&*()（）_+-=[]|{};':\",.<>?/";//规定的特殊字符，可以自己随意添加
    for (int i = 0; i < str.length; i++) {
        NSString *subStr = [str substringWithRange:NSMakeRange(i, 1)];
        if([specialCharacters containsString:subStr]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return @"";
}

+ (NSString *)getBundleVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
}

@end
