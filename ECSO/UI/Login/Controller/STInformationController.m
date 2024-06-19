//
//  STInformationController.m
//  ECSO
//
//  Created by YY on 2024/5/22.
//

#import "STInformationController.h"
#import "STLoginController.h"
#import "STMainTabbarController.h"
#import "STInputView.h"
#import "STHTTPRequest.h"
#import "STCacheManager.h"
#import "STUser.h"
#import "STNavigationController.h"
#import "STFindController.h"
@interface STInformationController () <UITextFieldDelegate>
@property (nonatomic, strong)STInputView *accountView;
@property (nonatomic, strong)STInputView *pwdView;
@property (nonatomic, strong)STInputView *fixView;
@property (nonatomic, strong)UIButton *nextBtn;

@property (nonatomic, strong)STHTTPRequest *request;
@end

@implementation STInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadData = false;
    self.isShowLoadView = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSubView];
}

- (STHTTPRequest *)request {
    if (_request == nil) {
        _request = [[STHTTPRequest alloc]init];
    }
    return _request;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
}

- (void)createSubView {
    UIImageView *dropView = [[UIImageView alloc]init];
    dropView.image = [UIImage imageNamed:@"login_drop"];
    [self.view addSubview:dropView];
    [dropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
        make.height.mas_offset(450);
    }];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.textColor = SXColorMain;
    tipLabel.font = [STFont fontStatus:medium fontSize:22];
    tipLabel.text = @"登录其他账户";
    [self.view addSubview:tipLabel];
    if ([STAppEnvs shareInstance].isIphoneX) {
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.view).offset(-18);
            make.top.equalTo(self.view).offset([STAppEnvs shareInstance].tabBarHeight + 42);
        }];
    } else if ([STAppEnvs shareInstance].isIPhone6Plus) {
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.view).offset(-18);
            make.top.equalTo(self.view).offset([STAppEnvs shareInstance].tabBarHeight + 20);
        }];
    } else {
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.view).offset(-18);
            make.top.equalTo(self.view).offset([STAppEnvs shareInstance].tabBarHeight + 5);
        }];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tipLabel addGestureRecognizer:tap];
    
    UIImageView *iconView = [[UIImageView alloc]init];
    [iconView sx_setImagePlaceholdWithURL:self.avatarUrl];
    iconView.layer.cornerRadius = 60;
    iconView.layer.borderColor = HexRGB(0xffffff).CGColor;
    iconView.layer.borderWidth = 4;
    iconView.clipsToBounds = true;
    [self.view addSubview:iconView];
    
    if ([STAppEnvs shareInstance].isIPhone6) {
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(tipLabel.mas_bottom).offset(15);
            make.size.mas_offset(CGSizeMake(120, 120));
        }];
    } else {
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(tipLabel.mas_bottom).offset(40);
            make.size.mas_offset(CGSizeMake(120, 120));
        }];
    }
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.textColor = SXColorMain;
    promptLabel.font = [STFont fontStatus:medium fontSize:17];
    promptLabel.text = self.userName;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-18);
        make.leading.equalTo(self.view).offset(18);
        make.top.equalTo(iconView.mas_bottom).offset(15);
    }];
    
    [self.view addSubview:self.accountView];
    if ([STAppEnvs shareInstance].isIphoneX) {
        [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view).offset(40);
            make.trailing.equalTo(self.view).offset(-40);
            make.top.equalTo(promptLabel.mas_bottom).offset(50);
        }];
    } else if ([STAppEnvs shareInstance].isIPhone6Plus) {
        [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view).offset(40);
            make.trailing.equalTo(self.view).offset(-40);
            make.top.equalTo(promptLabel.mas_bottom).offset(35);
        }];
    } else {
        [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view).offset(40);
            make.trailing.equalTo(self.view).offset(-40);
            make.top.equalTo(promptLabel.mas_bottom).offset(20);
        }];
    }
    
    [self.view addSubview:self.pwdView];
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.accountView);
        make.top.equalTo(self.accountView.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.fixView];
    [self.fixView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.accountView);
        make.top.equalTo(self.pwdView.mas_bottom).offset(20);
    }];
    
    UIButton *createBtn = [[UIButton alloc]init];
    [createBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x474E6F)] forState:UIControlStateNormal];
    [createBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = [STFont fontStatus:medium fontSize:18];
    createBtn.layer.cornerRadius = 8;
    createBtn.clipsToBounds = true;
    createBtn.enabled = false;
    [createBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    self.nextBtn = createBtn;
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.fixView);
        make.top.equalTo(self.fixView.mas_bottom).offset(27);
        make.height.mas_offset(50);
    }];
}

- (STInputView *)accountView {
    if (_accountView == nil) {
        _accountView = [[STInputView alloc]init];
        _accountView.nameLabel.text = @"账号";
        _accountView.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"账户名由6-15位字母数字组成" attributes:@{NSFontAttributeName:[STFont fontSize:16],NSForegroundColorAttributeName:HexRGB(0xC9C9C9)}];
        _accountView.textField.delegate = self;
    }
    return _accountView;
}

- (STInputView *)pwdView {
    if (_pwdView == nil) {
        _pwdView = [[STInputView alloc]init];
        _pwdView.nameLabel.text = @"密码";
        _pwdView.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入6-20位密码" attributes:@{NSFontAttributeName:[STFont fontSize:16],NSForegroundColorAttributeName:HexRGB(0xC9C9C9)}];
        _pwdView.textField.secureTextEntry = true;
        [_pwdView.textField addTarget:self action:@selector(textFieldDidChangeValue:)forControlEvents:UIControlEventEditingChanged];
    }
    return _pwdView;
}

- (STInputView *)fixView {
    if (_fixView == nil) {
        _fixView = [[STInputView alloc]init];
        _fixView.nameLabel.text = @"确认密码";
        _fixView.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请再次输入新密码" attributes:@{NSFontAttributeName:[STFont fontSize:16],NSForegroundColorAttributeName:HexRGB(0xC9C9C9)}];
        _fixView.textField.secureTextEntry = true;
        [_fixView.textField addTarget:self action:@selector(textFieldDidChangeValue:)forControlEvents:UIControlEventEditingChanged];
    }
    return _fixView;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= 15) {
        return NO;
    }
    if (string.length == 0) {
        return YES;
    }
    NSString *pattern = @"^[A-Za-z0-9]+$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    // 如果没有错误，并且至少有一个匹配项
    if (!error && [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])]) {
        return YES; // 字符串有效
    }
    return NO; // 字符串无效
}

- (void)textFieldDidChangeValue:(UITextField *)textField {
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
    if (self.fixView.textField.text.length >= 6 && self.pwdView.textField.text.length >= 6 && self.accountView.textField.text.length >= 6) {
        self.nextBtn.enabled = true;
    } else {
        self.nextBtn.enabled = false;
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    STLoginController *loginVc = [[STLoginController alloc]init];
    [self pushViewController:loginVc];
}


- (void)nextBtnAction {
    [SVProgressHelper showHUDWithStatus:@"正在注册..."];
    [self.request registerUser:self.accountView.textField.text password:self.pwdView.textField.text displayName:self.userName portrait:self.avatarUrl clientId:[STCacheManager shareInstance].getUUID success:^(id object) {
        STUser *user = object;
        [STUserDefault setObjectValue:user.token forKey:@"token"];
        [STUserDefault setObjectValue:user.userId forKey:@"userId"];
        [STUserDefault setObjectValue:user.portrait forKey:@"portrait"];
        [STUserDefault setObjectValue:user.userName forKey:@"userName"];
        [STUserDefault setObjectValue:user.displayName forKey:@"displayName"];
        [[STCacheManager shareInstance] saveWallers:user.wallets];
        [SVProgressHelper customDismiss:true message:@"注册成功" complete:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 主线程更新
            STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:[[STFindController alloc] init]];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        });
    } fail:^(FAILCODE stateCode, NSString *error) {
        [SVProgressHelper dismissWithMsg:error];
    }];
}

@end
