//
//  STLoginController.m
//  ECSO
//
//  Created by YY on 2024/5/27.
//

#import "STLoginController.h"
#import "STMainTabbarController.h"
#import "STNavigationController.h"
#import "STFindController.h"
#import "STInputView.h"
#import "STHTTPRequest.h"
#import "STUser.h"
@interface STLoginController () <UITextFieldDelegate>
@property (nonatomic, strong)STInputView *accountView;
@property (nonatomic, strong)STInputView *pwdView;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)STHTTPRequest *request;
@end

@implementation STLoginController

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

- (STInputView *)accountView {
    if (_accountView == nil) {
        _accountView = [[STInputView alloc]init];
        _accountView.nameLabel.text = @"账号";
        _accountView.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入账号" attributes:@{NSFontAttributeName:[STFont fontSize:16],NSForegroundColorAttributeName:HexRGB(0xC9C9C9)}];
        _accountView.textField.delegate = self;
    }
    return _accountView;
}

- (STInputView *)pwdView {
    if (_pwdView == nil) {
        _pwdView = [[STInputView alloc]init];
        _pwdView.nameLabel.text = @"密码";
        _pwdView.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSFontAttributeName:[STFont fontSize:16],NSForegroundColorAttributeName:HexRGB(0xC9C9C9)}];
        _pwdView.textField.secureTextEntry = true;
        [_pwdView.textField addTarget:self action:@selector(textFieldDidChangeValue:)forControlEvents:UIControlEventEditingChanged];
    }
    return _pwdView;
}

- (void)createSubView {
    
    UIImageView *dropView = [[UIImageView alloc]init];
    dropView.image = [UIImage imageNamed:@"login_drop"];
    [self.view addSubview:dropView];
    [dropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
        make.height.mas_offset(450);
    }];
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.textColor = SXColorMain;
    promptLabel.font = [STFont fontStatus:medium fontSize:18];
    promptLabel.text = @"请登录";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-18);
        make.leading.equalTo(self.view).offset(18);
        make.top.equalTo(self.view).offset([STAppEnvs shareInstance].statusBarHeight + 60);
    }];
    
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"login_header"];
    iconView.layer.cornerRadius = 60;
    iconView.layer.borderColor = HexRGB(0xffffff).CGColor;
    iconView.layer.borderWidth = 4;
    iconView.clipsToBounds = true;
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(promptLabel.mas_bottom).offset(30);
        make.size.mas_offset(CGSizeMake(120, 120));
    }];
    
    [self.view addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(40);
        make.trailing.equalTo(self.view).offset(-40);
        make.top.equalTo(iconView.mas_bottom).offset(60);
    }];
    [self.view addSubview:self.pwdView];
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.accountView);
        make.top.equalTo(self.accountView.mas_bottom).offset(20);
    }];
    
    UIButton *createBtn = [[UIButton alloc]init];
    [createBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x474E6F)] forState:UIControlStateNormal];
    [createBtn setTitle:@"登录" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = [STFont fontStatus:medium fontSize:18];
    createBtn.layer.cornerRadius = 8;
    createBtn.clipsToBounds = true;
    createBtn.enabled = false;
    [createBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    self.loginBtn = createBtn;
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.pwdView);
        make.top.equalTo(self.pwdView.mas_bottom).offset(40);
        make.height.mas_offset(50);
    }];
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
    if (textField.text.length > 20 && textField.markedTextRange == nil) {
        textField.text = [textField.text substringToIndex:20];
    }
    if (self.accountView.textField.text.length >= 6 && self.pwdView.textField.text.length >= 6) {
        self.loginBtn.enabled = true;
    } else {
        self.loginBtn.enabled = false;
    }
}

- (void)loginBtnAction {
    [SVProgressHelper showHUDWithStatus:@"正在登录..."];
    [self.request loginUser:self.accountView.textField.text password:self.pwdView.textField.text clientId:[[STCacheManager shareInstance] getUUID] success:^(id object) {
        STUser *user = object;
        [STUserDefault setObjectValue:user.token forKey:@"token"];
        [STUserDefault setObjectValue:user.userId forKey:@"userId"];
        [STUserDefault setObjectValue:user.portrait forKey:@"portrait"];
        [STUserDefault setObjectValue:user.userName forKey:@"userName"];
        [STUserDefault setObjectValue:user.displayName forKey:@"displayName"];
        [[STCacheManager shareInstance] saveWallers:user.wallets];
        [SVProgressHelper customDismiss:true message:@"登录成功" complete:nil];
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
