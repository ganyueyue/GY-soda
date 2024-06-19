//
//  STNickAvatarController.m
//  ECSO
//
//  Created by YY on 2024/5/22.
//

#import "STNickAvatarController.h"
#import "STInformationController.h"
#import "TZImagePickerController.h"
#import "STLoginController.h"
#import "STHTTPRequest.h"
@interface STNickAvatarController ()
@property (nonatomic, strong)UIButton *avatarBtn;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *nextBtn;
@property (nonatomic, strong)STHTTPRequest *request;

@property (nonatomic, strong)NSString *avatarUrl;
@end

@implementation STNickAvatarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadData = false;
    self.isShowLoadView = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
}

- (STHTTPRequest *)request {
    if (_request == nil) {
        _request = [[STHTTPRequest alloc]init];
    }
    return _request;
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
    tipLabel.userInteractionEnabled = true;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-18);
        make.top.equalTo(self.view).offset([STAppEnvs shareInstance].tabBarHeight + 42);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tipLabel addGestureRecognizer:tap];
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.textColor = SXColorMain;
    promptLabel.font = [STFont fontStatus:medium fontSize:23];
    promptLabel.text = @"HI, 给自己设置个形象吧~";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-18);
        make.leading.equalTo(self.view).offset(18);
        make.top.equalTo(tipLabel.mas_bottom).offset(55);
    }];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    hintLabel.textColor = SXColor9;
    hintLabel.font = [STFont fontSize:14];
    hintLabel.text = @"有形象的小伙伴更容易获得关注哦！";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hintLabel];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-18);
        make.leading.equalTo(self.view).offset(18);
        make.top.equalTo(promptLabel.mas_bottom).offset(11);
    }];
    
    self.avatarBtn = [[UIButton alloc]init];
    self.avatarBtn.backgroundColor = HexRGB(0xD9DFE9);
    self.avatarBtn.layer.cornerRadius = 60;
    self.avatarBtn.layer.borderColor = HexRGB(0xffffff).CGColor;
    self.avatarBtn.layer.borderWidth = 4;
    self.avatarBtn.clipsToBounds = true;
    [self.avatarBtn setBackgroundImage:[UIImage imageNamed:@"login_header"] forState:UIControlStateNormal];
    [self.avatarBtn setBackgroundImage:[UIImage imageNamed:@"login_header"] forState:UIControlStateHighlighted];
    [self.avatarBtn addTarget:self action:@selector(avatarBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.avatarBtn];
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(hintLabel.mas_bottom).offset(40);
        make.size.mas_offset(CGSizeMake(120, 120));
    }];
    
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"login_camera"];
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.avatarBtn.mas_trailing).offset(-10);
        make.bottom.equalTo(self.avatarBtn.mas_bottom).offset(-4);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(40);
        make.trailing.equalTo(self.view).offset(-40);
        make.height.mas_offset(50);
        make.top.equalTo(self.avatarBtn.mas_bottom).offset(40);
    }];
    
    UIButton *createBtn = [[UIButton alloc]init];
    [createBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x474E6F)] forState:UIControlStateNormal];
    [createBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = [STFont fontStatus:medium fontSize:18];
    createBtn.layer.cornerRadius = 8;
    createBtn.clipsToBounds = true;
    createBtn.enabled = false;
    [createBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    self.nextBtn = createBtn;
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.textField);
        make.top.equalTo(self.textField.mas_bottom).offset(35);
        make.height.mas_offset(50);
    }];
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc]init];
        _textField.font = [STFont fontSize:17];
        _textField.textColor = HexRGB(0x292F48);
        _textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入昵称，最多5个字" attributes:@{NSFontAttributeName:[STFont fontSize:17],NSForegroundColorAttributeName:HexRGB(0xC9C9C9)}];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.layer.borderColor = HexRGB(0x868686).CGColor;
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = 8;
        _textField.clipsToBounds = true;
        [_textField setAutocapitalizationType:(UITextAutocapitalizationTypeNone)];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.returnKeyType = UIReturnKeyDone;
        [_textField addTarget:self action:@selector(textFieldDidChangeValue:)forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)avatarBtnAction {
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
            [weakSelf.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
            [weakSelf.avatarBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        }
    };
    [self present:vc completion:nil];
}

- (void)saveLoginImage:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    [self.request uploadPortrait:image success:^(NSDictionary *object) {
        weakSelf.avatarUrl = object[@"url"];
    } fail:^(FAILCODE stateCode, NSString *error) {
        [SVProgressHelper dismissWithMsg:error];
    }];
    
}

- (void)nextBtnAction {
    if (self.avatarUrl.length <= 0) {
        [SVProgressHelper dismissWithMsg:@"请先上传头像"];
        return;
    }
    STInformationController *vc = [[STInformationController alloc]init];
    vc.userName = self.textField.text;
    vc.avatarUrl = self.avatarUrl;
    [self pushViewController:vc];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    STLoginController *loginVc = [[STLoginController alloc]init];
    [self pushViewController:loginVc];
}

- (void)textFieldDidChangeValue:(UITextField *)textField {
    if (textField.text.length > 5 && textField.markedTextRange == nil) {
        textField.text = [textField.text substringToIndex:5];
    }
    if (textField.text.length > 0 && textField.markedTextRange == nil) {
        self.nextBtn.enabled = true;
    } else {
        self.nextBtn.enabled = false;
    }
}

@end
