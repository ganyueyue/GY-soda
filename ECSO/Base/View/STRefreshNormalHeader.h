//
//  STRefreshNormalHeader.h
//  Swim
//
//  Created by YY on 2022/9/13.
//

#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface STRefreshNormalHeader : MJRefreshNormalHeader
@property (strong, nonatomic) UIActivityIndicatorView *loadView;
@end

NS_ASSUME_NONNULL_END
