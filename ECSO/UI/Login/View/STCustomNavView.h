//
//  STCustomNavView.h
//  ECSO
//
//  Created by YY on 2024/5/24.
//

#import "STView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^STNavItemBlock)(NSInteger index);

@interface STCustomNavView : STView
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *saveBtn;

@property (nonatomic, copy)STNavItemBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
