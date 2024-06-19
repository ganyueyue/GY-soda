//
//  STPwdPopupView.h
//  Swim
//
//  Created by YY on 2022/3/30.
//

#import "STView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^STPwdPopupClickBlock)(NSInteger index);
@interface STPwdPopupView : STView
@property (nonatomic, copy)STPwdPopupClickBlock clickBlock ;
- (void)show;
- (void)createSubViewPlatform:(STSharePlatform *)info withImageUrl:(NSString *)imageUrl withTextHidden:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
