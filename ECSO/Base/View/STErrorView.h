//
//  STErrorView.h
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STView.h"
@class STErrorView;
NS_ASSUME_NONNULL_BEGIN

@protocol STErrorViewDelegate <NSObject>

- (void)touchErrorView:(STErrorView *)view;

@end

@interface STErrorView : STView

@property (nonatomic, weak)id<STErrorViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
