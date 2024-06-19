//
//  STFindSearchView.h
//  ECSO
//
//  Created by YY on 2024/5/24.
//

#import "STView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^STClickBlock)(NSInteger index);

@interface STFindSearchView : STView
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, copy)STClickBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
