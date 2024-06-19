//
//  STModifyNickController.m
//  ECSO
//
//  Created by YY on 2024/5/24.
//

#import "STModifyNickController.h"
#import "STCustomNavView.h"
#import "STHTTPRequest.h"
@interface STModifyNickController ()
@property (nonatomic, strong)STCustomNavView *navView;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)STHTTPRequest *request;
@end

@implementation STModifyNickController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadData = false;
    self.isShowLoadView = false;
    self.view.backgroundColor = HexRGB(0xF5F5F5);
    
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.mas_offset([STAppEnvs shareInstance].statusBarHeight + 50);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.navView.clickBlock = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf backAction:nil];
        } else {
            [weakSelf saveChangeDisplayName];
        }
    };
    
    [self createSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
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
        _navView.backgroundColor = [UIColor whiteColor];
    }
    return _navView;
}

- (void)createSubView {
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 5;
    backgroundView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1300].CGColor;
    backgroundView.layer.shadowOffset = CGSizeMake(0,1);
    backgroundView.layer.shadowOpacity = 1;
    backgroundView.layer.shadowRadius = 4;
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.top.equalTo(self.navView.mas_bottom).offset(16);
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.font = [STFont fontSize:16];
    _textField.textColor = HexRGB(0x292F48);
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.layer.borderColor = HexRGB(0xbcbcbc).CGColor;
    _textField.layer.borderWidth = 0.5;
    _textField.layer.cornerRadius = 6;
    _textField.clipsToBounds = true;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.returnKeyType = UIReturnKeyDone;
    [_textField addTarget:self action:@selector(textFieldDidChangeValue:)forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:_textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView).offset(13);
        make.leading.equalTo(backgroundView).offset(15);
        make.trailing.equalTo(backgroundView).offset(-15);
        make.height.mas_offset(45);
    }];
    
    _textField.text = [STUserDefault objectValueForKey:@"displayName"];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textField becomeFirstResponder];
    });
    
    UILabel *tipsLabel = [[UILabel alloc]init];
    tipsLabel.text = @"好名字可以让你的朋友 更容易记住你。";
    tipsLabel.textColor = HexRGB(0x888888);
    tipsLabel.font = [STFont fontSize:12];
    [backgroundView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.textField);
        make.top.equalTo(self.textField.mas_bottom).offset(13);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-11);
    }];
}

- (void)textFieldDidChangeValue:(UITextField *)textField {
    if (textField.text.length > 5 && textField.markedTextRange == nil) {
        textField.text = [textField.text substringToIndex:5];
    }
    if (textField.text.length > 0 && textField.markedTextRange == nil) {
        self.navView.saveBtn.enabled = true;
    } else {
        self.navView.saveBtn.enabled = false;
    }
}


- (void)saveChangeDisplayName {
    [self.view endEditing:true];
    __weak typeof(self) weakSelf = self;
    [self.request changeDisplayname:self.textField.text success:^(id object) {
        [STUserDefault setObjectValue:weakSelf.textField.text forKey:@"displayName"];
        [SVProgressHelper customDismiss:true message:@"修改昵称成功" complete:^{
            [weakSelf popViewController:nil];
        }];
    } fail:^(FAILCODE stateCode, NSString *error) {
        [SVProgressHelper dismissWithMsg:error];
    }];
}

@end
