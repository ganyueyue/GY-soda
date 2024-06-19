//
//  STPopoverView.h
//  Swim
//
//  Created by YY on 2022/3/14.
//

#import "STView.h"
@class STMenuInfo;
NS_ASSUME_NONNULL_BEGIN
typedef void(^STClickPopoVewBlock)(STMenuInfo *);

@interface STPopoverView : STView
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)STClickPopoVewBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
