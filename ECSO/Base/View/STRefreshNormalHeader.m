//
//  STRefreshNormalHeader.m
//  Swim
//
//  Created by YY on 2022/9/13.
//

#import "STRefreshNormalHeader.h"

@implementation STRefreshNormalHeader

- (UIActivityIndicatorView *)loadView
{
    if (!_loadView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        loadingView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [self addSubview:_loadView = loadingView];
    }
    return _loadView;
}

@end
