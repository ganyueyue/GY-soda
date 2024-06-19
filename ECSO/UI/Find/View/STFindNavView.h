//
//  STFindNavView.h
//  ECSO
//
//  Created by YY on 2024/5/23.
//

#import "STView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^STFindItemBlock)(NSInteger index);
@interface STFindNavView : STView
@property (nonatomic, copy)STFindItemBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
