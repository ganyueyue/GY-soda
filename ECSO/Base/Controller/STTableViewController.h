//
//  STTableViewController.h
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STBaseViewController.h"
#import "STEmptyView.h"
NS_ASSUME_NONNULL_BEGIN

@interface STTableViewController : STBaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) UITableViewStyle style;

@property (nonatomic, strong) STEmptyView *emptyView;

@property (nonatomic, assign) STPullState refreshState; //下拉刷新
@property (nonatomic, assign) STPullState loadMoreState;//加载更多

-(void)headerRefreshEnd;
-(void)footerRefreshEnd;
@end

NS_ASSUME_NONNULL_END
