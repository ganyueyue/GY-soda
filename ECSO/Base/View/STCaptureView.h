//
//  STCaptureView.h
//  Swim
//
//  Created by YY on 2022/12/20.
//

#import "STView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^STCaptureClickBlock)(NSInteger index, UIImage *image);

@interface STCaptureView : STView
@property (nonatomic, copy)STCaptureClickBlock clickBlock ;
- (void)show;
- (void)createSubViewPlatform:(STSharePlatform *)info withShowView:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
