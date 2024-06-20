//
//  STAboutController.m
//  ECSO
//
//  Created by YY on 2024/6/18.
//

#import "STAboutController.h"
#import "STAboutCell.h"
#import "STCustomNavView.h"
@interface STAboutController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong)STCustomNavView *navView;
@end

@implementation STAboutController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadData = false;
    self.isShowLoadView = false;
    self.view.backgroundColor = HexRGB(0xf7f7f7);
    
    self.dataArray = @[@"免责协议".string,@"用户协议".string,@"隐私政策".string];
    
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.mas_offset([STAppEnvs shareInstance].statusBarHeight + 50);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.navView.clickBlock = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf backAction:nil];
        }
    };
    
    [self createSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
}

- (STCustomNavView *)navView {
    if (_navView == nil) {
        _navView = [[STCustomNavView alloc]init];
        _navView.titleLabel.text = @"关于".string;
        _navView.saveBtn.hidden = true;
        _navView.backgroundColor = [UIColor whiteColor];
    }
    return _navView;
}

- (void)createSubView {
    
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"common_logo"];
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom).offset(40);
        make.width.height.mas_offset(80);
    }];
    
    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.textColor = HexRGB(0x888888);
    versionLabel.font = [STFont fontSize:13];
    versionLabel.text = [NSString stringWithFormat:@"v %@",[self getAppVersion]];
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconView);
        make.top.equalTo(iconView.mas_bottom).offset(10);
    }];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionLabel.mas_bottom).offset(60);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
        make.height.mas_offset(150);
    }];
}


- (UITableView *)tableView {
    if (_tableView != nil){
        return _tableView;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.allowsSelection = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 75;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = HexRGB(0xFFFFFF);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = false;
    _tableView.userInteractionEnabled = true;
    _tableView.layer.cornerRadius = 10;
    _tableView.clipsToBounds = true;
    [_tableView registerClass:[STAboutCell class] forCellReuseIdentifier:[STAboutCell className]];
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:[STAboutCell className]];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        STWebViewController *vc = [[STWebViewController alloc]init];
        vc.urlString = [STCacheManager shareInstance].getAPPInfo.appDisclaimerUrl;
        [self pushViewController:vc];
    } else if (indexPath.row == 1) {
        STWebViewController *vc = [[STWebViewController alloc]init];
        vc.urlString = [STCacheManager shareInstance].getAPPInfo.appUserAgreementUrl;
        [self pushViewController:vc];
    } else if (indexPath.row == 2) {
        STWebViewController *vc = [[STWebViewController alloc]init];
        vc.urlString = [STCacheManager shareInstance].getAPPInfo.appPrivacyPolicyUrl;
        [self pushViewController:vc];
    }
}

- (NSString *)getAppVersion{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

@end
