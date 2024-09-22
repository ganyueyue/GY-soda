//
//  STVisitCell.h
//  ECSO
//
//  Created by YY on 2024/5/24.
//

#import "STBaseTableViewCell.h"
#import "STWebInfo.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^STSelectedBlock)(void);

@interface STVisitCell : STBaseTableViewCell
@property (nonatomic, strong)STWebInfo *webInfo;

@property (nonatomic, strong)UIButton *topBtn;

@property (nonatomic, copy)STSelectedBlock block;
@end

NS_ASSUME_NONNULL_END
