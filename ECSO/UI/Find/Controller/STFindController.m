//
//  STFindController.m
//  ECSO
//
//  Created by YY on 2024/5/23.
//

#import "STFindController.h"
#import "STFindNavView.h"
#import "STFindSearchView.h"
#import "STUserInfoController.h"
#import "STVisitCell.h"
#import "ECSO-Swift.h"
#import "STWebInfo.h"
#import "STAdvertController.h"
@interface STFindController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)STFindSearchView *searchView;
@property (nonatomic, strong)UIButton *avatarBtn;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation STFindController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadData = false;
    self.isShowLoadView = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSubView];
    [self.dataArray addObjectsFromArray:[STCacheManager shareInstance].getHistory];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHistory:) name:kHistoryChangeNotification object:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getPasswordAddress];
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
    
    NSString *portrait = [STUserDefault objectValueForKey:@"portrait"];
    if (portrait.length > 0) {
        [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:portrait] forState:UIControlStateNormal];
    }
}

- (STFindSearchView *)searchView {
    if (_searchView == nil) {
        _searchView = [[STFindSearchView alloc]init];
        _searchView.textField.delegate = self;
    }
    return _searchView;
}

- (UITableView *)tableView {
    if (_tableView != nil){
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.allowsSelection = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 70;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = false;
    [_tableView registerClass:[STVisitCell class] forCellReuseIdentifier:[STVisitCell className]];
    if(@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding=0;
    }     //去掉headerpadding的高度
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)createSubView {
    __weak typeof(self) weakSelf = self;
    self.avatarBtn = [[UIButton alloc]init];
    self.avatarBtn.layer.cornerRadius = 30;
    self.avatarBtn.clipsToBounds = true;
    [self.avatarBtn addTarget:self action:@selector(didSelectedAvatar) forControlEvents:UIControlEventTouchUpInside];
    NSString *portrait = [STUserDefault objectValueForKey:@"portrait"];
    if (portrait.length > 0) {
        [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:portrait] forState:UIControlStateNormal];
    }
    [self.view addSubview:self.avatarBtn];
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset([STAppEnvs shareInstance].statusBarHeight + 40);
        make.width.height.mas_offset(60);
    }];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"common_logo"];
    logoView.layer.cornerRadius = 12;
    logoView.clipsToBounds = true;
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.avatarBtn.mas_bottom).offset(60);
        make.width.height.mas_offset(110);
    }];
    
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.top.equalTo(logoView.mas_bottom).offset(40);
        make.height.mas_offset(50);
    }];

    self.searchView.clickBlock = ^(NSInteger index) {
        if (index == 0) {
            STScanViewController *vc = [[STScanViewController alloc]init];
            [weakSelf pushViewController:vc];
        } else {
            
        }
    };
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.searchView.mas_bottom);
    }];
}

- (void)getPasswordAddress {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];//获取系统等剪切板
    if (pasteboard.string.length > 0 && pasteboard.strings.count == 1) {
        NSString *string = pasteboard.string;
        if ([NSString isCheckUrl:string.lowercaseString]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                STWebViewController *vc = [[STWebViewController alloc] init];
                vc.urlString = string;
                [self pushViewController:vc];
            });
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return nil;
    }
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 30)];
    titleLabel.font = [STFont fontStatus:medium fontSize:15];
    titleLabel.text = @"最近访问".string;
    titleLabel.textColor = HexRGB(0x606060);
    [sectionView addSubview:titleLabel];
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 15, 30, 30)];
    [deleteBtn setImage:[UIImage imageNamed:@"find_delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:deleteBtn];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 0.001;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STVisitCell *cell = [tableView dequeueReusableCellWithIdentifier:[STVisitCell className] forIndexPath:indexPath];
    cell.webInfo = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STWebViewController *vc = [[STWebViewController alloc] init];
    STWebInfo *info = self.dataArray[indexPath.row];
    vc.urlString = info.url;
    [self pushViewController:vc];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        STWebInfo *info = self.dataArray[indexPath.row];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [[STCacheManager shareInstance]deleteCache:info.url];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([NSString isCheckUrl:textField.text.lowercaseString]) {
        STWebViewController *vc = [[STWebViewController alloc] init];
        vc.urlString = textField.text;
        [self pushViewController:vc];
    }
    [self.view endEditing:true];
    return true;
}

- (void)changeHistory:(NSNotification *)notification {
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[[STCacheManager shareInstance]getHistory]];
    [self.tableView reloadData];
}

- (void)didSelectedAvatar {
    STUserInfoController *vc = [[STUserInfoController alloc]init];
    [self pushViewController:vc];
}

- (void)deleteAction {
    [[STCacheManager shareInstance] deleteHistory];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

@end
