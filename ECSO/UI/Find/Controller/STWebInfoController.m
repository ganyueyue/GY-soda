//
//  STWebInfoController.m
//  ECSO
//
//  Created by YY on 2024/8/21.
//

#import "STWebInfoController.h"
#import "STVisitCell.h"
#import "STCustomNavView.h"
#import "NoticeHelp.h"
@interface STWebInfoController ()
@property (nonatomic, strong)STCustomNavView *navView;
@end

@implementation STWebInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadData = false;
    self.isShowLoadView = false;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[STVisitCell class] forCellReuseIdentifier:[STVisitCell className]];
    self.tableView.allowsMultipleSelection = true;
    self.tableView.allowsSelectionDuringEditing = true;
    self.tableView.allowsMultipleSelectionDuringEditing = true;
    
    [self.view addSubview:self.navView];

    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.mas_offset([STAppEnvs shareInstance].statusBarHeight + 50);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.navView.clickBlock = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf backAction:nil];
        } else {
            [weakSelf cancelAction];
        }
    };
    if (self.selectedIndex == 1) {
        [self.navView.saveBtn setTitle:@"清空".string forState:UIControlStateNormal];
        self.navView.saveBtn.hidden = false;
        self.navView.titleLabel.text = @"历史记录".string;
        [self.dataArray addObjectsFromArray:[STCacheManager shareInstance].getHistory];
    } else {
        self.navView.titleLabel.text = @"推荐".string;
        self.navView.saveBtn.hidden = true;
        [self.dataArray addObjectsFromArray:[STCacheManager shareInstance].getRecommend];
    }
}

- (STCustomNavView *)navView {
    if (_navView == nil) {
        _navView = [[STCustomNavView alloc] init];
        _navView.backgroundColor = [UIColor whiteColor];
    }
    return _navView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STVisitCell *cell = [tableView dequeueReusableCellWithIdentifier:[STVisitCell className] forIndexPath:indexPath];
    STWebInfo *info = self.dataArray[indexPath.row];
    cell.webInfo = info;
    if (indexPath.row == 0 || self.selectedIndex != 1) {
        cell.topBtn.hidden = true;
    } else {
        cell.topBtn.hidden = false;
    }
    __weak typeof(self) weakSelf = self;
    cell.block = ^{
        [[STCacheManager shareInstance] saveCache:info.title withUrl:info.url withIcon:info.icon];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:[STCacheManager shareInstance].getHistory];
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STWebViewController *vc = [[STWebViewController alloc] init];
    STWebInfo *info = self.dataArray[indexPath.row];
    vc.urlString = info.url;
    [self pushViewController:vc];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == 1) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && self.selectedIndex == 1) {
        [NoticeHelp showChoiceAlertInViewController:self title:@"提示".string message:@"您确定要删除此条历史记录吗？".string tapBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                STWebInfo *info = self.dataArray[indexPath.row];
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                [[STCacheManager shareInstance]deleteCache:info.url];
                [SVProgressHelper customDismiss:true message:@"删除成功".string complete:nil];
            }
        }];
        
        
    }
}

- (void)cancelAction {
    [NoticeHelp showChoiceAlertInViewController:self title:@"提示".string message:@"您确定要清空历史记录吗？".string tapBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[STCacheManager shareInstance] deleteHistory];
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [SVProgressHelper customDismiss:true message:@"清空成功".string complete:nil];
        }
    }];
}

@end
