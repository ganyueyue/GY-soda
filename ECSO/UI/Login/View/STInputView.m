//
//  STInputView.m
//  ECSO
//
//  Created by YY on 2024/5/22.
//

#import "STInputView.h"

@implementation STInputView

- (void)setup {
    [super setup];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [STFont fontStatus:medium fontSize:15];
    self.nameLabel.textColor = SXColor3;
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.font = [STFont fontSize:17];
    _textField.textColor = HexRGB(0x292F48);
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.layer.borderColor = HexRGB(0x868686).CGColor;
    _textField.layer.borderWidth = 0.5;
    _textField.layer.cornerRadius = 8;
    _textField.clipsToBounds = true;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.returnKeyType = UIReturnKeyDone;
    [self addSubview:_textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(17);
        make.leading.bottom.trailing.equalTo(self);
        make.height.mas_offset(50);
    }];
}

@end
