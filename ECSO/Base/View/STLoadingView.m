//
//  STLoadingView.m
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STLoadingView.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface STLoadingView ()
@property (nonatomic, strong)FLAnimatedImageView *imageView;
@end

@implementation STLoadingView

- (FLAnimatedImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[FLAnimatedImageView alloc]init];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
        _imageView.animatedImage = animatedImage;
    }
    return _imageView;
}

- (void)setup {
    [super setup];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-20);
        make.size.mas_offset(CGSizeMake(250, 250));
    }];
}

@end
