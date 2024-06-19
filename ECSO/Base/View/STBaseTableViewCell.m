//
//  STBaseTableViewCell.m
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STBaseTableViewCell.h"

@interface STBaseTableViewCell ()
@property (nonatomic, strong, readwrite) UIView *lineView;
@end

@implementation STBaseTableViewCell

- (instancetype)init{
    
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] className]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexRGB(0xe6e6e6);
    }
    return _lineView;
}

- (void)setLineHeight:(CGFloat)lineHeight {

    _lineHeight = lineHeight;
    
    if (_lineHeight <= 0) {
        _lineHeight = 0;
    }
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(_lineHeight);
    }];
}

-(void)setLineEdge:(UIEdgeInsets)lineEdge{
    if (UIEdgeInsetsEqualToEdgeInsets(_lineEdge, lineEdge)){
        return;
    }
    _lineEdge = lineEdge;
    
    if (_lineHeight == 0) {
        _lineHeight = 0.5;
    }
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(_lineEdge.left);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(_lineEdge.right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(_lineEdge.bottom);
        make.height.mas_equalTo(_lineHeight);
    }];
}

-(NSIndexPath *)indexPath{
    
    UIView *superView = self.superview;
    UITableView *superTableView = nil;
    
    while (superView != nil) {
        if ([superView isKindOfClass:[UITableView class]]){
            superTableView = (UITableView *)superView;
            break;
        }
        superView = superView.superview;
    }
    
    if (superTableView ==nil){
        return nil;
    }
    return [superTableView indexPathForCell:self];
    
}

@end
