//
//  STAppItemViewCell.h
//  Swim
//
//  Created by YY on 2022/3/21.
//

#import "STBaseCollectionViewCell.h"
#import "STWebInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface STAppItemViewCell : STBaseCollectionViewCell
@property (nonatomic, strong)STWebInfo *webInfo;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *iconView;
@end

NS_ASSUME_NONNULL_END
