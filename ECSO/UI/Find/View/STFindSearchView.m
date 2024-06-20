//
//  STFindSearchView.m
//  ECSO
//
//  Created by YY on 2024/5/24.
//

#import "STFindSearchView.h"

@implementation STFindSearchView

- (void)setup {
    [super setup];
    
    self.layer.borderColor = HexRGB(0xBCBCBC).CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 8;
    self.clipsToBounds = true;
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [searchBtn setImage:[UIImage imageNamed:@"find_scan"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.mas_offset(50);
    }];
    
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self).offset(50);
        make.trailing.equalTo(self).offset(-50);
    }];
    
    UIButton *codeBtn = [[UIButton alloc]init];
    [codeBtn setImage:[UIImage imageNamed:@"find_code"] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(scanCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self);
        make.width.mas_offset(50);
    }];
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc]init];
        _textField.font = [STFont fontSize:16];
        _textField.textColor = HexRGB(0x292F48);
        _textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"搜索".string attributes:@{NSFontAttributeName:[STFont fontSize:16],NSForegroundColorAttributeName:HexRGB(0x888888)}];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.clipsToBounds = true;
        [_textField setAutocapitalizationType:(UITextAutocapitalizationTypeNone)];
        _textField.returnKeyType = UIReturnKeySearch;
    }
    return _textField;
}


- (void)searchBtnAction {
    if (self.clickBlock) {
        self.clickBlock(1);
    }
}

- (void)scanCodeBtnAction {
    if (self.clickBlock) {
        self.clickBlock(0);
    }
}

@end
