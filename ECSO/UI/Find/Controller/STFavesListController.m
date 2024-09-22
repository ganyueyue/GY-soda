//
//  STFavesListController.m
//  ECSO
//
//  Created by YY on 2024/9/2.
//

#import "STFavesListController.h"
#import "STVisitCell.h"
#import "STCustomNavView.h"
#import "NoticeHelp.h"
@interface STFavesListController ()
@property (nonatomic, strong)STCustomNavView *navView;
@end

@implementation STFavesListController

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
        }
    };
       
    self.navView.titleLabel.text = @"我的收藏".string;
        self.navView.saveBtn.hidden = true;
        [self.dataArray addObjectsFromArray:[STCacheManager shareInstance].getFaves];
    
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
    if (indexPath.row == 0) {
        cell.topBtn.hidden = true;
    } else {
        cell.topBtn.hidden = false;
    }
    __weak typeof(self) weakSelf = self;
    cell.block = ^{
        [[STCacheManager shareInstance] saveFavesCache:info.title withUrl:info.url withIcon:info.icon];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:[STCacheManager shareInstance].getFaves];
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
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [NoticeHelp showChoiceAlertInViewController:self title:@"提示".string message:@"您确定要删除此条收藏记录吗？".string tapBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                STWebInfo *info = self.dataArray[indexPath.row];
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                [[STCacheManager shareInstance] deleteFaves:info.url];
                [SVProgressHelper customDismiss:true message:@"删除成功".string complete:nil];
            }
        }];
        
        
    }
}

@end
