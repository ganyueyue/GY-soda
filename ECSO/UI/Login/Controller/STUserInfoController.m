//
//  STUserInfoController.m
//  ECSO
//
//  Created by YY on 2024/5/29.
//

#import "STUserInfoController.h"
#import "STModifyNickController.h"
#import "TZImagePickerController.h"
#import "STAboutController.h"
#import "STCustomNavView.h"
#import "STUserItem.h"
#import "STHTTPRequest.h"
@interface STUserInfoController ()
@property (nonatomic, strong)STCustomNavView *navView;
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *nickLabel;
@property (nonatomic, strong)STHTTPRequest *request;
@end

@implementation STUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadData = false;
    self.isShowLoadView = false;
    self.view.backgroundColor = HexRGB(0xf5f5f5);
    
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
    self.nickLabel.text = [STUserDefault objectValueForKey:@"displayName"];
}

- (STHTTPRequest *)request {
    if (_request == nil) {
        _request = [[STHTTPRequest alloc]init];
    }
    return _request;
}

- (STCustomNavView *)navView {
    if (_navView == nil) {
        _navView = [[STCustomNavView alloc]init];
        _navView.backgroundColor = HexRGB(0xf5f5f5);
        _navView.titleLabel.text = @"用户信息".string;
        _navView.saveBtn.hidden = true;
    }
    return _navView;
}

- (void)createSubView {
    self.iconView = [[UIImageView alloc]init];
    self.iconView.layer.cornerRadius = 40;
    self.iconView.layer.borderColor = HexRGB(0xffffff).CGColor;
    self.iconView.layer.borderWidth = 4;
    self.iconView.clipsToBounds = true;
    self.iconView.userInteractionEnabled = true;
    [self.view addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.navView.mas_bottom).offset(20);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar:)];
    [self.iconView addGestureRecognizer:avatarTap];
    
    self.nickLabel = [[UILabel alloc]init];
    self.nickLabel.textColor = SXColorMain;
    self.nickLabel.font = [STFont fontStatus:medium fontSize:22];
    [self.view addSubview:self.nickLabel];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).offset(20);
        make.bottom.equalTo(self.iconView.mas_centerY).offset(-2);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    UILabel *accountLabel = [[UILabel alloc]init];
    accountLabel.textColor = SXColorMain;
    accountLabel.font = [STFont fontSize:17];
    [self.view addSubview:accountLabel];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).offset(20);
        make.top.equalTo(self.iconView.mas_centerY).offset(2);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    [self.iconView sx_setImagePlaceholdWithURL:[STUserDefault objectValueForKey:@"portrait"]];
    self.nickLabel.text = [STUserDefault objectValueForKey:@"displayName"];
    accountLabel.text = [NSString stringWithFormat:@"%@:%@",@"账号".string,[STUserDefault objectValueForKey:@"userName"]];
    
    STUserItem *item = [[STUserItem alloc] init];
    item.titleLabel.text = @"设置昵称或别名".string;
    item.tag = 100;
    [item addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:item];
    [item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(16);
        make.trailing.equalTo(self.view).offset(-16);
        make.top.equalTo(self.iconView.mas_bottom).offset(20);
    }];
    
    STUserItem *item1 = [[STUserItem alloc] init];
    item1.titleLabel.text = @"关于".string;
    item1.tag = 101;
    [item1 addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:item1];
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(16);
        make.trailing.equalTo(self.view).offset(-16);
        make.top.equalTo(item.mas_bottom).offset(20);
    }];
}

- (void)tap:(UIControl *)tap {
    NSInteger tag = tap.tag - 100;
    if (tag == 0) {
        STModifyNickController *vc = [[STModifyNickController alloc]init];
        [self pushViewController:vc];
    } else {
        STAboutController *vc = [[STAboutController alloc] init];
        [self pushViewController:vc];
    }
}

- (void)changeAvatar:(UITapGestureRecognizer *)tap {
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 columnNumber:4 delegate:nil];
    vc.allowCrop = true;
    vc.allowPickingVideo = false;
    vc.allowTakePicture = false;
    vc.cropRect = CGRectMake(0, (ScreenHeight - ScreenWidth) * 0.5, ScreenWidth, ScreenWidth);
    vc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            UIImage *image = photos.firstObject;
            [weakSelf saveLoginImage:image];
        }
    };
    [self present:vc completion:nil];
}

- (void)saveLoginImage:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    [SVProgressHelper showHUDWithStatus:@"正在上传..."];
    [self.request uploadPortrait:image success:^(NSDictionary *object) {
        [weakSelf changePortrait:object[@"url"] withImage:image];
    } fail:^(FAILCODE stateCode, NSString *error) {
        [SVProgressHelper dismissWithMsg:error];
    }];
    
}

- (void)changePortrait:(NSString *)url withImage:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    [self.request changePortrait:url success:^(id object) {
        [SVProgressHelper customDismiss:true message:@"修改头像成功"];
        [STUserDefault setObjectValue:url forKey:@"portrait"];
        weakSelf.iconView.image = image;
    } fail:^(FAILCODE stateCode, NSString *error) {
        [SVProgressHelper dismissWithMsg:error];
    }];
}

@end
