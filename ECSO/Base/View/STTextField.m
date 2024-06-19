//
//  STTextField.m
//  Swim
//
//  Created by GanYue on 2022/3/11.
//

#import "STTextField.h"

@implementation STTextField

- (CGRect) rightViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 15;
    return textRect;
}

@end
