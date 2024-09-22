//
//  STFindController.m
//  ECSO
//
//  Created by YY on 2024/5/23.
//

#import "STFindController.h"
#import "STFindNavView.h"
#import "STFindSearchView.h"
#import "STUserInfoController.h"
#import "STVisitCell.h"
#import "ECSO-Swift.h"
#import "STWebInfo.h"
#import "STAdvertController.h"
#import "STAppItemViewCell.h"
#import "UIView+Extension.h"
#import "STWebInfoController.h"
#import "STFavesListController.h"
#import "STMainTabbarController.h"
@interface STFindController () <UITextFieldDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong)STFindSearchView *searchView;
@property (nonatomic, strong)UIButton *avatarBtn;

@property (nonatomic, strong) UIButton *favoritesButton;
@property (nonatomic, strong) UIButton *historyButton;
@property (nonatomic, strong) UIView *underlineView;

@property (nonatomic, strong) UIButton *recommendedButton;
@property (nonatomic, strong) UIView *recommendedUnderlineView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *favoritesCollectionView;
@property (nonatomic, strong) UICollectionView *historyCollectionView;
@property (nonatomic, strong) UICollectionView *recommendedCollectionView;
@property (nonatomic, strong) STEmptyView *emptyView;
@property (nonatomic, strong) STEmptyView *emptyView1;
@property (nonatomic, strong) STEmptyView *emptyView2;

@property (nonatomic, strong)NSMutableArray *favesArray;
@property (nonatomic, strong)NSMutableArray *historyArray;
@property (nonatomic, strong)NSMutableArray *remeArray;
@end

@implementation STFindController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadData = false;
    self.isShowLoadView = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"icon_drop"];
    logoView.layer.cornerRadius = 12;
    logoView.clipsToBounds = true;
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.leading.equalTo(self.view);
        make.height.mas_offset(237);
    }];
    
    NSInteger lang = [STUserDefault integerValueForKey:@"STLanguage"];
    if (lang == 0) {
        NSString *language = [NSLocale preferredLanguages][0];
        if ([language.lowercaseString hasPrefix:@"zh"]) {
            lang = 1;
        } else if ([language.lowercaseString hasPrefix:@"ja"]) {
            lang = 3;
        } else if ([language.lowercaseString hasPrefix:@"ko"]) {
            lang = 4;
        } else {
            lang = 2;
        }
    }
    NSArray *list = @[@"icon_zn",@"icon_en",@"icon_jp",@"icon_hg"];
    UIButton *languageBtn = [[UIButton alloc] init];
    [languageBtn setBackgroundImage:[UIImage imageNamed:list[lang - 1]] forState:UIControlStateNormal];
    [languageBtn addTarget:self action:@selector(languageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:languageBtn];
    [languageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-20);
        make.size.mas_offset(CGSizeMake(35, 35));
        make.top.equalTo(self.view).offset([STAppEnvs shareInstance].statusBarHeight);
    }];
    
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset([STAppEnvs shareInstance].statusBarHeight + 50);
        make.height.mas_offset(50);
    }];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:254/255.0 alpha:1];
    
    // 添加我的收藏和我的历史按钮
    self.favoritesButton = [self createButtonWithTitle:@"我的收藏".string];
    self.favoritesButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.favoritesButton.selected = TRUE;
    self.historyButton = [self createButtonWithTitle:@"历史记录".string];
    self.historyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.historyButton.selected = false;
    // 设置按钮位置
    self.favoritesButton.frame = CGRectMake(20, 180, 80, 30);
    self.historyButton.frame = CGRectMake(120, 180, 80, 30);
    
    [self.view addSubview:self.favoritesButton];
    [self.view addSubview:self.historyButton];
    
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width -120, 180, 100, 30)];
    moreBtn.tag = 100;
    [moreBtn setTitle:@"更多".string forState:UIControlStateNormal];
    [moreBtn setTitleColor:HexRGB(0x9a9a9a) forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [STFont fontSize:14];
    [moreBtn setImage:[UIImage imageNamed:@"common_arrow"] forState:UIControlStateNormal];
    [moreBtn setImagePositionWithType:(LXImagePositionTypeRight) spacing:5];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    
    // 添加底部下划线
    self.underlineView = [[UIView alloc] initWithFrame:CGRectMake(50, self.favoritesButton.bottom, 23, 4)];
    self.underlineView.backgroundColor = HexRGB(0x536EEB);
    self.underlineView.layer.cornerRadius = 2;
    self.underlineView.clipsToBounds = true;
    [self.view addSubview:self.underlineView];
    
    // 初始化ScrollView
    CGFloat collectionViewWidth = self.view.frame.size.width - 40; // 留出左右各20pt的距离
    CGFloat itemWidth = (collectionViewWidth - 120) / 5; // 5列
    CGFloat itemHeigth = (itemWidth + 50)* 2 ; // 5列
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, self.favoritesButton.bottom + 15, collectionViewWidth, itemHeigth)];
    self.scrollView.contentSize = CGSizeMake(collectionViewWidth * 2, itemHeigth);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor]; // ScrollView透明，便于查看背景颜色
    [self.view addSubview:self.scrollView];
    
    // 初始化我的收藏和我的历史CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeigth); // 设置cell大小，左右各留出10pt间隙
    layout.minimumInteritemSpacing = 20; // 设置列间距
    layout.minimumLineSpacing = 20; // 设置行间距
    // 我的收藏 CollectionView
    self.favoritesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, collectionViewWidth, itemHeigth) collectionViewLayout:layout];
    self.favoritesCollectionView.backgroundColor = [UIColor whiteColor];
    self.favoritesCollectionView.delegate = self;
    self.favoritesCollectionView.dataSource = self;
    self.favoritesCollectionView.emptyDataSetDelegate = self;
    self.favoritesCollectionView.emptyDataSetSource = self;
    self.favoritesCollectionView.layer.cornerRadius = 10;
    self.favoritesCollectionView.clipsToBounds = true;
    [self.favoritesCollectionView registerClass:[STAppItemViewCell class] forCellWithReuseIdentifier:@"STAppItemViewCell"];
    
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.itemSize = CGSizeMake(itemWidth, itemHeigth); // 设置cell大小，左右各留出10pt间隙
    layout2.minimumInteritemSpacing = 20; // 设置列间距
    layout2.minimumLineSpacing = 20; // 设置行间距
    // 我的历史 CollectionView
    self.historyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(collectionViewWidth, 0, collectionViewWidth, itemHeigth) collectionViewLayout:layout2];
    self.historyCollectionView.backgroundColor = [UIColor whiteColor];
    self.historyCollectionView.delegate = self;
    self.historyCollectionView.dataSource = self;
    self.historyCollectionView.emptyDataSetDelegate = self;
    self.historyCollectionView.emptyDataSetSource = self;
    self.historyCollectionView.layer.cornerRadius = 10;
    self.historyCollectionView.clipsToBounds = true;
    [self.historyCollectionView registerClass:[STAppItemViewCell class] forCellWithReuseIdentifier:@"STAppItemViewCell1"];
    
    // 添加CollectionView到ScrollView
    [self.scrollView addSubview:self.favoritesCollectionView];
    [self.scrollView addSubview:self.historyCollectionView];
    
    // 初始化推荐按钮和CollectionView
    self.recommendedButton = [self createButtonWithTitle:@"推荐".string];
    self.recommendedButton.frame = CGRectMake(20,  self.scrollView.bottom + 10 , 140, 30);
    self.recommendedButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.recommendedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.recommendedButton.selected = TRUE;
    [self.view addSubview:self.recommendedButton];
    
    UIButton *moreBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width -120, self.scrollView.bottom + 10 , 100, 30)];
    moreBtn1.tag = 101;
    [moreBtn1 setTitle:@"更多".string forState:UIControlStateNormal];
    [moreBtn1 setTitleColor:HexRGB(0x9a9a9a) forState:UIControlStateNormal];
    moreBtn1.titleLabel.font = [STFont fontSize:14];
    [moreBtn1 setImage:[UIImage imageNamed:@"common_arrow"] forState:UIControlStateNormal];
    [moreBtn1 setImagePositionWithType:(LXImagePositionTypeRight) spacing:5];
    moreBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [moreBtn1 addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn1];
    
    // 添加推荐部分的下划线
    self.recommendedUnderlineView = [[UIView alloc] initWithFrame:CGRectMake(25, self.scrollView.bottom + 40, 23, 4)];
    self.recommendedUnderlineView.backgroundColor = HexRGB(0x536EEB);
    self.recommendedUnderlineView.layer.cornerRadius = 2;
    self.recommendedUnderlineView.clipsToBounds = true;
    [self.view addSubview:self.recommendedUnderlineView];
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.itemSize = CGSizeMake(itemWidth, itemHeigth); // 设置cell大小，左右各留出10pt间隙
    layout1.minimumInteritemSpacing = 20; // 设置列间距
    layout1.minimumLineSpacing = 20; // 设置行间距
    // 推荐 CollectionView
    self.recommendedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, self.scrollView.bottom + 55, collectionViewWidth, itemHeigth) collectionViewLayout:layout1];
    self.recommendedCollectionView.backgroundColor = [UIColor whiteColor];
    self.recommendedCollectionView.layer.cornerRadius = 10;
    self.recommendedCollectionView.clipsToBounds = true;
    self.recommendedCollectionView.delegate = self;
    self.recommendedCollectionView.dataSource = self;
    self.recommendedCollectionView.emptyDataSetDelegate = self;
    self.recommendedCollectionView.emptyDataSetSource = self;
    [self.recommendedCollectionView registerClass:[STAppItemViewCell class] forCellWithReuseIdentifier:@"STAppItemViewCell2"];
    [self.view addSubview:self.recommendedCollectionView];
    
    self.searchView.clickBlock = ^(NSInteger index) {
        if (index == 0) {
            STScanViewController *vc = [[STScanViewController alloc]init];
            [weakSelf pushViewController:vc];
        } else {
            
        }
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHistory:) name:kHistoryChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFaves:) name:kFavesChangeNotification object:nil];}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:89/255.0 green:101/255.0 blue:126/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:2/255.0 green:9/255.0 blue:25/255.0 alpha:1.0] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button addTarget:self action:@selector(tabButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tabButtonTapped:(UIButton *)sender {
    if (sender == self.favoritesButton) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == self.historyButton) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];
    } else {
        
    }
}

- (NSMutableArray *)favesArray {
    if (_favesArray == nil) {
        _favesArray = [NSMutableArray array];
        [_favesArray addObjectsFromArray:[STCacheManager shareInstance].getFaves];
    }
    return _favesArray;
}

- (NSMutableArray *)remeArray {
    if (_remeArray == nil) {
        _remeArray = [NSMutableArray array];
        [_remeArray addObjectsFromArray:[STCacheManager shareInstance].getRecommend];
    }
    return _remeArray;
}

- (NSMutableArray *)historyArray {
    if (_historyArray == nil) {
        _historyArray = [NSMutableArray array];
        [_historyArray addObjectsFromArray:[STCacheManager shareInstance].getHistory];
    }
    return _historyArray;
}

- (STEmptyView *)emptyView1 {
    if (_emptyView1 == nil) {
        _emptyView1 = [[STEmptyView alloc]initWithFrame:self.view.bounds];
        _emptyView1.titleLabel.text = @"暂无数据".string;
    }
    return _emptyView1;
}

- (STEmptyView *)emptyView2 {
    if (_emptyView2 == nil) {
        _emptyView2 = [[STEmptyView alloc]initWithFrame:self.view.bounds];
        _emptyView2.titleLabel.text = @"暂无数据".string;
    }
    return _emptyView2;
}

- (STEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[STEmptyView alloc]initWithFrame:self.view.bounds];
        _emptyView.titleLabel.text = @"暂无数据".string;
    }
    return _emptyView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    if (page == 0) {
        [self selectTab:self.favoritesButton];
    } else if (page == 1) {
        [self selectTab:self.historyButton];
    }
}

- (void)selectTab:(UIButton *)button {
    if (button == self.favoritesButton) {
        self.favoritesButton.selected = true;
        self.favoritesButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.historyButton.selected = NO;
        self.historyButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    } else {
        self.historyButton.selected = true;
        self.historyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.favoritesButton.selected = NO;
        self.favoritesButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.underlineView.frame;
        frame.origin.x = button.frame.origin.x + 30;
        self.underlineView.frame = frame;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([NSString isCheckUrl:textField.text.lowercaseString] || [NSString checkUrlWithString:textField.text.lowercaseString]) {
        STWebViewController *vc = [[STWebViewController alloc] init];
        vc.urlString = textField.text;
        [self pushViewController:vc completion:^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];//获取系统等剪切板
            pasteboard.string = @"";
        }];
    }
    [self.view endEditing:true];
    return true;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.favoritesCollectionView) {
        return self.favesArray.count < 10 ? self.favesArray.count : 10; // 返回0以显示黄色view
    } else if (collectionView == self.recommendedCollectionView) {
        return self.remeArray.count < 10 ? self.remeArray.count : 10; // 这里可根据需要调整数量
    }else if (collectionView == self.historyCollectionView) {
        return self.historyArray.count < 10 ? self.historyArray.count : 10; // 超过5个的数量
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.favoritesCollectionView) {
        STAppItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STAppItemViewCell" forIndexPath:indexPath];
        cell.webInfo = self.favesArray[indexPath.row];
        return cell;
    } else if (collectionView == self.historyCollectionView) {
        STAppItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STAppItemViewCell1" forIndexPath:indexPath];
        cell.webInfo = self.historyArray[indexPath.row];
        return cell;
    }
    STAppItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STAppItemViewCell2" forIndexPath:indexPath];
    cell.webInfo = self.remeArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.favoritesCollectionView) {
        STWebInfo *webInfo = self.favesArray[indexPath.row];
        STWebViewController *vc = [[STWebViewController alloc] init];
        vc.urlString = webInfo.url;
        [self pushViewController:vc];
    } else if (collectionView == self.historyCollectionView) {
        STWebInfo *webInfo = self.historyArray[indexPath.row];
        STWebViewController *vc = [[STWebViewController alloc] init];
        vc.urlString = webInfo.url;
        [self pushViewController:vc];
    } else if (collectionView == self.recommendedCollectionView) {
        STWebInfo *webInfo = self.remeArray[indexPath.row];
        STWebViewController *vc = [[STWebViewController alloc] init];
        vc.urlString = webInfo.url;
        [self pushViewController:vc];
    }
   
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return true;
}

-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if (scrollView == self.historyCollectionView) {
        return self.emptyView1;
    } else if (scrollView == self.favoritesCollectionView) {
        return self.emptyView2;
    }
    return self.emptyView;
}


- (void)moreBtnAction:(UIButton *)btn {
    if (btn.tag == 101) {
        STWebInfoController *vc = [[STWebInfoController alloc] init];
        vc.selectedIndex = 2;
        [self pushViewController:vc];
    } else if (self.favoritesButton.isSelected) {
        STFavesListController *vc = [[STFavesListController alloc] init];
        [self pushViewController:vc];
    } else {
        STWebInfoController *vc = [[STWebInfoController alloc] init];
        vc.selectedIndex = 1;
        [self pushViewController:vc];
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat collectionViewWidth = collectionView.frame.size.width;
    CGFloat itemWidth = (collectionViewWidth - 120) / 5; // 5列
    return CGSizeMake(itemWidth, itemWidth + 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20); // 设置 section 的内边距
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getPasswordAddress];
    });
    
}

- (STFindSearchView *)searchView {
    if (_searchView == nil) {
        _searchView = [[STFindSearchView alloc]init];
        _searchView.textField.delegate = self;
    }
    return _searchView;
}


- (void)getPasswordAddress {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];//获取系统等剪切板
    if (pasteboard.string.length > 0 && pasteboard.strings.count == 1) {
        NSString *string = pasteboard.string;
        if ([NSString isCheckUrl:string.lowercaseString]|| [NSString checkUrlWithString:string.lowercaseString]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                STWebViewController *vc = [[STWebViewController alloc] init];
                vc.urlString = string;
                [self pushViewController:vc completion:^{
                    pasteboard.string = @"";
                }];
            });
        } else if (string.length > 0) {
            NSRange startRange = [string rangeOfString:@"】"];
            NSRange endRange = [string rangeOfString:@"「"];
            if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
                NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                NSString *result = [string substringWithRange:range];
                if (result.length > 0) {
                    if ([NSString isCheckUrl:result] || [NSString checkUrlWithString:result]) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            STWebViewController *vc = [[STWebViewController alloc] init];
                            vc.urlString = result;
                            [self pushViewController:vc completion:^{
                                pasteboard.string = @"";
                            }];
                        });
                    }
                }
            }
            pasteboard.string = @"";
        } else {
            pasteboard.string = @"";
        }
    }
}

- (void)changeHistory:(NSNotification *)notification {
    [self.historyArray removeAllObjects];
    [self.historyArray addObjectsFromArray:[STCacheManager shareInstance].getHistory];
    [self.historyCollectionView reloadData];
}

- (void)changeFaves:(NSNotification *)notification {
    [self.favesArray removeAllObjects];
    [self.favesArray addObjectsFromArray:[STCacheManager shareInstance].getFaves];
    [self.favoritesCollectionView reloadData];
}

- (void)languageBtnAction:(UIButton *)btn {
    NSArray *list = @[@"中文".string,@"英文".string,@"日文".string,@"韩文".string];
    [NoticeHelp showActionSheetViewControllerTitle:nil customView:nil duration:0.25 buttonTitles:list tapBlock:^(NSInteger buttonIndex) {
        [STUserDefault setintegerValue:buttonIndex + 1 forKey:@"STLanguage"];
        if (buttonIndex == 0) {
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_zn"] forState:UIControlStateNormal];
        } else  if (buttonIndex == 1) {
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_en"] forState:UIControlStateNormal];
        }  else  if (buttonIndex == 2) {
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_jp"] forState:UIControlStateNormal];
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_hg"] forState:UIControlStateNormal];
        }
        [UIApplication sharedApplication].keyWindow.rootViewController = [[STMainTabbarController alloc] init];
    } complete:^{
        
    }];
}

@end
