//
//  STComplainController.m
//  ECSO
//
//  Created by YY on 2024/5/31.
//

#import "STComplainController.h"
#import "STCustomNavView.h"
#import "ECSO-Swift.h"
#import "STHTTPRequest.h"
@interface STComplainController () <UITextViewDelegate>
@property (nonatomic, strong)STHTTPRequest *request;
@property (nonatomic, strong)STCustomNavView *navView;
@property (nonatomic, strong)UIButton *editBtn;
@property (nonatomic, strong) KMPlaceholderTextView*textView;
@property (nonatomic, strong)UIButton *nextBtn;
@property (nonatomic, assign)NSInteger type;
@end

@implementation STComplainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadData = false;
    self.isShowLoadView = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
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

- (STHTTPRequest *)request {
    if (_request == nil) {
        _request = [[STHTTPRequest alloc]init];
    }
    return _request;
}

- (STCustomNavView *)navView {
    if (_navView == nil) {
        _navView = [[STCustomNavView alloc] init];
        _navView.backgroundColor = HexRGB(0xf5f5f5);
        _navView.titleLabel.text = @"投诉";
        _navView.saveBtn.hidden = true;
    }
    return _navView;
}

- (KMPlaceholderTextView *)textView {
    if (_textView == nil) {
        _textView = [[KMPlaceholderTextView alloc]init];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _textView.textColor = HexRGB(0x344356);
        _textView.placeholder = @"请输入投诉内容";
        _textView.placeholderColor = HexRGB(0xA3A3A3);
        _textView.font = [STFont fontSize:15];
        _textView.backgroundColor = HexRGB(0xf7f7f7);
        _textView.layer.cornerRadius = 4;
        _textView.clipsToBounds = true;
        _textView.delegate = self;
    }
    return _textView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
}

- (void)createSubView {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [STFont fontStatus:medium fontSize:18];
    titleLabel.textColor = SXColorMain;
    titleLabel.text = @"投诉类型";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.navView.mas_bottom).offset(20);
    }];
    
    self.editBtn = [[UIButton alloc] init];
    [self.editBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:SXColor9 forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = [STFont fontSize:17];
    [self.editBtn setImage:[UIImage imageNamed:@"common_arrow"] forState:UIControlStateNormal];
    [self.editBtn setImagePositionWithType:(LXImagePositionTypeRight) spacing:8];
    [self.editBtn addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.trailing.equalTo(self.view).offset(-20);
        make.size.mas_offset(CGSizeMake(100, 30));
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = [STFont fontStatus:medium fontSize:18];
    tipsLabel.textColor = SXColorMain;
    tipsLabel.text = @"投诉内容";
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(40);
    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
        make.top.equalTo(tipsLabel.mas_bottom).offset(20);
        make.height.mas_offset(150);
    }];
    
    UIButton *createBtn = [[UIButton alloc]init];
    [createBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x474E6F)] forState:UIControlStateNormal];
    [createBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = [STFont fontStatus:medium fontSize:18];
    createBtn.layer.cornerRadius = 8;
    createBtn.clipsToBounds = true;
    createBtn.enabled = false;
    [createBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    self.nextBtn = createBtn;
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.textView);
        make.top.equalTo(self.textView.mas_bottom).offset(40);
        make.height.mas_offset(50);
    }];
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (textView.text.length > 0 && self.type != 0) {
        self.nextBtn.enabled = true;
    } else {
        self.nextBtn.enabled = false;
    }
}

- (void)selectTypeAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    NSArray *list = @[@"诈骗",@"黄色",@"暴力",@"政治",@"赌博"];
    [NoticeHelp showActionSheetViewControllerTitle:nil customView:nil duration:0.25 buttonTitles:list tapBlock:^(NSInteger buttonIndex) {
        weakSelf.type = buttonIndex + 1;
        [sender setTitle:list[buttonIndex] forState:UIControlStateNormal];
        [sender setImagePositionWithType:(LXImagePositionTypeRight) spacing:8];
        sender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        if (weakSelf.textView.text.length > 0) {
            weakSelf.nextBtn.enabled = true;
        } else {
            weakSelf.nextBtn.enabled = false;
        }
    } complete:nil];
}

- (void)nextBtnAction {
    [self.view endEditing:true];
    __weak typeof(self) weakSelf = self;
    [self.request complaint:self.urlString type:self.type description:self.textView.text success:^(id object) {
        [SVProgressHelper customDismiss:true message:@"投诉成功" complete:^{
            [weakSelf popViewController:nil];
        }];
    } fail:^(FAILCODE stateCode, NSString *error) {
        [SVProgressHelper dismissWithMsg:error];
    }];
}

@end
