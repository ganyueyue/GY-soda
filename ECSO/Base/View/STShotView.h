//
//  STShotView.h
//  Swim
//
//  Created by YY on 2022/8/23.
//

#import "STView.h"
#import "STShare.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^STShotViewClickBlock)(NSInteger index, UIImage *image);
@interface STShotView : STView
@property (nonatomic, copy)STShotViewClickBlock clickBlock ;
- (void)show;
- (void)createSubViewPlatform:(STSharePlatform *)info withShowView:(UIView *)view withTitle:(NSString *)title withDesc:(NSString *)desc withUrlString:(NSString *)urlString;
@end


NS_ASSUME_NONNULL_END
