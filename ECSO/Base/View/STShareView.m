//
//  STShareView.m
//  Swim
//
//  Created by YY on 2022/3/14.
//

#import "STShareView.h"
#import "STShareItemCell.h"
#import "STShare.h"
@interface STShareView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation STShareView

static STShareView* _instance = nil;

- (void)setup {
    [super setup];
    
    self.translatesAutoresizingMaskIntoConstraints = false;
    
    self.contentViewHeight = 140 + [STAppEnvs shareInstance].safeAreaBottomHeight;
    
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.mas_offset(self.contentViewHeight);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [STFont fontSize:16];
    titleLabel.textColor = SXColor3;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"分享到";
    [self.backgroundView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundView);
        make.height.mas_offset(15);
        make.top.equalTo(self.backgroundView).offset(17);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HexRGBA(0x292F48,0.1);
    [self.backgroundView addSubview:lineView];
    self.lineView = lineView;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backgroundView).offset(16);
        make.trailing.equalTo(self.backgroundView).offset(-16);
        make.height.mas_offset(1);
        make.top.equalTo(titleLabel.mas_bottom).offset(16);
    }];
    
    [self.backgroundView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backgroundView);
        make.top.equalTo(lineView.mas_bottom);
        make.height.mas_offset(floor(ScreenWidth * 0.25));
    }];
    
    UIView *dropView = [[UIView alloc]init];
    [self addSubview:dropView];
    [dropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.bottom.equalTo(self.backgroundView.mas_top);
    }];
    
    
    UITapGestureRecognizer *closeBtn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBtnAction)];
    [dropView addGestureRecognizer:closeBtn];

}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat itemWidth = floor((ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight) * 0.25);
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = HexRGB(0xf8f8f8);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = FALSE;
        _collectionView.showsHorizontalScrollIndicator = FALSE;
        [_collectionView registerClass:[STShareItemCell class] forCellWithReuseIdentifier:[STShareItemCell className]];
    }
    return _collectionView;
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, self.contentViewHeight)];
        _backgroundView.backgroundColor = HexRGB(0xF8F8F8);
        [_backgroundView setCornerOnTopRadius:30];
    }
    return _backgroundView;
}


- (void)setDataArray:(NSArray *)dataArray {
    if (_dataArray == dataArray) {
        return;
    }
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    STShareItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[STShareItemCell className] forIndexPath:indexPath];
    cell.platform = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    STSharePlatform *info = self.dataArray[indexPath.row];
    [self hidden];
    if (self.shareClick) {
        self.shareClick(info);
    }
}


- (void)closeBtnAction {
    [self hidden];
}

-(void)show {
    self.hidden = NO;
    self.backgroundView.backgroundColor = HexRGB(0xF8F8F8);
    self.backgroundView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, self.contentViewHeight);
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundView.frame = CGRectMake(0, ScreenHeight - self.contentViewHeight, ScreenWidth, self.contentViewHeight);
        self.backgroundColor = HexRGBA(0x000000, 0.3);
    }];
}


-(void)hidden {

    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, self.contentViewHeight);
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
}
@end
