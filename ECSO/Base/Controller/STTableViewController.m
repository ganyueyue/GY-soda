//
//  STTableViewController.m
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "STRefreshNormalHeader.h"
@interface STTableViewController ()

@end

@implementation STTableViewController

-(void)setup{
    [super setup];
    self.style = UITableViewStylePlain;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refreshState = STPullStateNO;
    _loadMoreState = STPullStateNO;

    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self.view);
    }];
    
}

- (STEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[STEmptyView alloc]initWithFrame:self.view.bounds];
        _emptyView.backgroundColor = [UIColor clearColor];
    }
    return _emptyView;
}

-(UITableView *)tableView{
    if (_tableView != nil){
        return _tableView;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.style];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.scrollsToTop = YES;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.allowsSelection = YES;
    _tableView.allowsSelectionDuringEditing = NO;
    _tableView.estimatedRowHeight = 50;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = HexRGB(0xf7f7f7);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (_dataArray != nil){
        return _dataArray;
    }
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    return _dataArray;
}

- (void)setRefreshState:(STPullState)refreshState {
    _refreshState = refreshState;
    __weak typeof(self) weakSelf = self;
    if (_refreshState == STPullStateNO){
        self.tableView.mj_header = nil;
    }else if(_refreshState == STPullStateIdle){
        if (self.tableView.mj_header == nil){
            STRefreshNormalHeader *header = [STRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf contentRefresh];
            }];

            [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
            [header setTitle:@"" forState:MJRefreshStateRefreshing];
            [header setTitle:@"释放更新" forState:MJRefreshStatePulling];

            header.arrowView.image = [UIImage imageNamed:@"common_refresh_down"];
            header.stateLabel.font = [UIFont fontWithName:@"PingFang-SC-Light" size:10];
            header.stateLabel.textColor = HexRGB(0xb1b1b1);
            header.lastUpdatedTimeLabel.hidden = YES;
            header.labelLeftInset = 10;


            self.tableView.mj_header = header;
        }
        self.tableView.mj_header.state = MJRefreshStateIdle;
    }
}

- (void)setLoadMoreState:(STPullState)loadMoreState {
    _loadMoreState = loadMoreState;
    __weak typeof(self) weakSelf = self;
    if (_loadMoreState == STPullStateNO){
        self.tableView.mj_footer = nil;
    }else if(_loadMoreState == STPullStateIdle){
        if (self.tableView.mj_footer == nil){

            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                //数据请求
                [weakSelf contentLoadMore];
            }];
            self.tableView.mj_footer = footer;
        }
        self.tableView.mj_footer.state = MJRefreshStateIdle;

    }else if(_loadMoreState == STPullStateNoMoreDate){
        if (self.tableView.mj_footer == nil){

            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf contentLoadMore];
            }];
        }
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void)headerRefreshEnd{
    [self.tableView.mj_header endRefreshing];
}

-(void)footerRefreshEnd{
    if(self.tableView.mj_footer.state != MJRefreshStateNoMoreData){
        self.tableView.mj_footer.state = MJRefreshStateIdle;
    }
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return true;
}

-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    return self.emptyView;
}

-(UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return HexRGB(0xF7F7F7);
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    [self.tableView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
