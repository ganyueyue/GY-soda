//
//  NSAttributedString+Extension.m
//  Swim
//
//  Created by YY on 2022/3/11.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)

// 实现图文混排的方法
+ (NSAttributedString *) creatAttrStringWithText:(NSString *)text withColor:(UIColor *)color image:(UIImage *) image{
    
    // NSTextAttachment可以将图片转换为富文本内容
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    // 通过NSTextAttachment创建富文本
    attachment.bounds = CGRectMake(0, -3, 15, 15);
    // 图片的富文本
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 文字的富文本
    NSAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[STFont fontSize:12],NSForegroundColorAttributeName : color}];
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    // 将图片、文字拼接
    // 如果要求图片在文字的后面只需要交换下面两句的顺序
    [mutableAttr appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@"    "]];
    [mutableAttr appendAttributedString:imageAttr];
    [mutableAttr appendAttributedString:textAttr];
    
    return [mutableAttr copy];
}

// 实现图文混排的方法
+ (NSAttributedString *) creatAttrStringWithPag:(NSString *)pag withText:(NSString *)text withColor:(UIColor *)color image:(UIImage *) image {
    
    // NSTextAttachment可以将图片转换为富文本内容
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    // 通过NSTextAttachment创建富文本
    attachment.bounds = CGRectMake(0, -3, 15, 15);
    // 图片的富文本
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 文字的富文本
    NSAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[STFont fontSize:12],NSForegroundColorAttributeName : color}];
    
    NSAttributedString *pagAttr = [[NSMutableAttributedString alloc] initWithString:pag];
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    // 将图片、文字拼接
    // 如果要求图片在文字的后面只需要交换下面两句的顺序
    [mutableAttr appendAttributedString:pagAttr];
    [mutableAttr appendAttributedString:imageAttr];
    [mutableAttr appendAttributedString:textAttr];
    
    return [mutableAttr copy];
}


@end
