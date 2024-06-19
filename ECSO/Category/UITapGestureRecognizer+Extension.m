//
//  UITapGestureRecognizer+Extension.m
//  SXTraining
//
//  Created by YY on 2019/12/17.
//  Copyright © 2019 YY. All rights reserved.
//

#import "UITapGestureRecognizer+Extension.h"
#import <objc/runtime.h>


@implementation UITapGestureRecognizer (Extension)

- (void)setFileUrl:(NSString *)fileUrl {
    objc_setAssociatedObject(self, @selector(fileUrl), fileUrl, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)fileUrl {
    return objc_getAssociatedObject(self, @selector(fileUrl));
}

- (void)setFileName:(NSString *)fileName {
    objc_setAssociatedObject(self, @selector(fileName), fileName, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)fileName {
    return objc_getAssociatedObject(self, @selector(fileName));
}


@end
