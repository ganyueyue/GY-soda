//
//  UIImageView+Extension.m
//  SXTraining
//
//  Created by YY on 2019/11/26.
//  Copyright © 2019 YY. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)sx_setImagePlaceholdWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeImage {
    
    NSURL *url =[NSURL URLWithString:urlString];
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = true;
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url placeholderImage:placeImage options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil){
            weakSelf.backgroundColor = [UIColor clearColor];
            weakSelf.image = image;
        }
    }];
}

-(void)sx_setImagePlaceholdWithURL:(NSString *)urlString{
    
    if (urlString == nil){
        urlString = @"";
    }
    
    if ([urlString isKindOfClass:[NSNull class]]) {
        urlString = @"";
    }
    
    if (urlString.length <= 0) {
        self.image = [UIImage imageNamed:@"common_placeholder"];
    }
    
    [self sx_setImagePlaceholdWithURL:urlString placeholderImage:[UIImage imageNamed:@"common_placeholder"]];
}


@end
