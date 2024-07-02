//
//  STWebViewController.m
//  Swim
//
//  Created by YY on 2022/3/11.
//

#import "STWebViewController.h"
#import "STErrorView.h"
#import "STLoadingView.h"
#import "STNavtionItem.h"
#import "STPopoverView.h"
#import "ECSO-Swift.h"
#import "STShare.h"
#import "STMenuInfo.h"
#import "NSData+Extension.h"
#import "UIColor+Extension.h"
#import "NSDictionary+Extension.h"
#import "STShareView.h"
#import "STShotView.h"
#import "STCaptureView.h"
#import "STPwdPopupView.h"
#import "STCall.h"
#import "STComplainController.h"
#import "TZImagePickerController.h"
@interface STWebViewController () <STErrorViewDelegate,STAuthorizationDelegate>

@property (nonatomic, strong) STErrorView *errorView;
@property (nonatomic, strong) STLoadingView *loadingView;

@property (nonatomic, strong) STNavtionItem *navtionItem;
@property (nonatomic, strong) STPopoverView *popoverView;
@property (nonatomic, strong) Popover *popover;

@property (nonatomic, strong) NSMutableArray <STMenuInfo *>*menuList;

@property (nonatomic, strong) STShareView *shareView;

@property (nonatomic, weak) KYPopupViewController *popupViewController;

@property (nonatomic, strong) STAuthorization *authorizationView;

@property (nonatomic, strong) STShare *share;

@end

@implementation STWebViewController

- (void)dealloc
{
    NSLog(@"dealloc %@",self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init{
    WKWebViewConfiguration *cofig = [[WKWebViewConfiguration alloc] init];
    cofig.allowsInlineMediaPlayback = YES;
    cofig.mediaTypesRequiringUserActionForPlayback = false;
    cofig.preferences = [[WKPreferences alloc] init];
    // 默认为0
    cofig.preferences.minimumFontSize = 10;
    // 默认认为YES
    cofig.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    cofig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // web内容处理池
    cofig.processPool = [[WKProcessPool alloc] init];
    // 将所有cookie以document.cookie = 'key=value';形式进行拼接
    
    NSString *cookieValue = [NSString stringWithFormat:@"document.cookie = 'fromapp=ios';document.cookie = 'osLocale=zh-CN';document.cookie = 'deviceTarget=%@';",[STCacheManager shareInstance].getUUID];
    
    // 加cookie给h5识别，表明在ios端打开该地址
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript *cookieScript = [[WKUserScript alloc]
                                   initWithSource: cookieValue
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    WKUserScript *reloadScript = [[WKUserScript alloc] initWithSource:@"window.addEventListener('pageshow', function(event){if(event.persisted){location.reload();}});"
                                                                        injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                                     forMainFrameOnly:YES];
    [userContentController addUserScript: reloadScript];
    
    cofig.userContentController = userContentController;
    
    NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                    WKWebsiteDataTypeDiskCache,
                                    WKWebsiteDataTypeMemoryCache,
                                    ]];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

    }];
    
    if (self = [super initWithConfiguration:cofig]){
        self.configuration = cofig;
        [self setup];
    }
    return self;
}

-(id)initWithConfiguration:(WKWebViewConfiguration *)configuration{
    if (self = [super initWithConfiguration:configuration]){
        configuration.allowsInlineMediaPlayback = YES;
        configuration.mediaTypesRequiringUserActionForPlayback = false;
        configuration.preferences = [[WKPreferences alloc] init];
        // 默认为0
        configuration.preferences.minimumFontSize = 10;
        // 默认认为YES
        configuration.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // web内容处理池
        configuration.processPool = [[WKProcessPool alloc] init];
        // 将所有cookie以document.cookie = 'key=value';形式进行拼接
        NSString *cookieValue = [NSString stringWithFormat:@"document.cookie = 'fromapp=ios';document.cookie = 'osLocale=zh-CN';document.cookie = 'deviceTarget=%@';",[STCacheManager shareInstance].getUUID];
        
        // 加cookie给h5识别，表明在ios端打开该地址
        WKUserContentController* userContentController = WKUserContentController.new;
        WKUserScript * cookieScript = [[WKUserScript alloc]
                                       initWithSource: cookieValue
                                       injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        configuration.userContentController = userContentController;
        
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                        WKWebsiteDataTypeDiskCache,
                                        WKWebsiteDataTypeMemoryCache,
                                        ]];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

        }];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        
    }
    return self;
}

-(void)setup{
    self.hidesBottomBarWhenPushed = true;
}

-(void)addScriptMessageHander{
    [self removeScriptMessageHander];
    [self.configuration.userContentController addScriptMessageHandler:self name:@"callApp"];
    [self.configuration.userContentController addScriptMessageHandler:self name:@"onAppCallResult"];
}

-(void)removeScriptMessageHander{
    [self.configuration.userContentController removeScriptMessageHandlerForName:@"callApp"];
    [self.configuration.userContentController removeScriptMessageHandlerForName:@"onAppCallResult"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.actionButtonHidden = true;
    self.view.backgroundColor = [UIColor whiteColor];
    self.wkWebView.backgroundColor = [UIColor whiteColor];
    if(@available(iOS 11.0, *)) {
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.wkWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset([STAppEnvs shareInstance].statusBarHeight);
    }];
    
    [self.view addSubview:self.navtionItem];
    [self.navtionItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-10);
        make.size.mas_offset(CGSizeMake(85, 30));
        make.top.equalTo(self.view).offset([STAppEnvs shareInstance].statusBarHeight + 6);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.navtionItem.clickBlock = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf backAction];
        } else {
            [weakSelf showPopoverView];
        }
    };
        
}

- (NSMutableArray *)menuList {
    if (_menuList == nil) {
        _menuList = [NSMutableArray array];
    }
    return _menuList;
}

- (STPopoverView *)popoverView {
    if (_popoverView == nil) {
        _popoverView = [[STPopoverView alloc]init];
    }
    return _popoverView;
}

- (STShareView *)shareView {
    if (_shareView == nil) {
        _shareView = [[STShareView alloc]init];
    }
    return _shareView;
}

- (STNavtionItem *)navtionItem {
    if (_navtionItem == nil) {
        _navtionItem = [[STNavtionItem alloc]init];
        _navtionItem.layer.cornerRadius = 15;
        _navtionItem.layer.borderColor = HexRGB(0xE6E6E6).CGColor;
        _navtionItem.layer.borderWidth = 0.5;
        _navtionItem.clipsToBounds = true;
    }
    return _navtionItem;
}

- (Popover *)popover {
    if (_popover == nil) {
        _popover = [[Popover alloc]init];
    }
    return _popover;
}

- (STShare *)share {
    if (_share == nil) {
        _share = [[STShare alloc] init];
    }
    return _share;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
    [self.navigationController setToolbarHidden:true animated:false];
    [self addScriptMessageHander];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self removeScriptMessageHander];
    [super viewWillDisappear:animated];
}

- (STErrorView *)errorView {
    if (_errorView == nil) {
        _errorView = [[STErrorView alloc]initWithFrame:self.view.bounds];
        _errorView.delegate = self;
        [self.view addSubview:_errorView];
    }
    return _errorView;
}

- (STLoadingView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[STLoadingView alloc]initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = [UIColor whiteColor];
    }
    return _loadingView;
}

- (void)showLoadingView
{
    [self.view addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.view);
    }];
    [self.view bringSubviewToFront:self.loadingView];
    [self.view bringSubviewToFront:self.navtionItem];
    [self.errorView removeFromSuperview];
}

- (void)hiddenLoadingView
{
    [self.errorView removeFromSuperview];
    [self.loadingView removeFromSuperview];
}

-(void)setUrlString:(NSString *)urlString{
    if (_urlString == urlString) {
        return;
    }
    _urlString = urlString;
    if (![_urlString.lowercaseString containsString:@"http"]) {
        _urlString = [NSString stringWithFormat:@"http://%@",_urlString];
    }
    [self loadCurrentURL];
}

- (void)setFileName:(NSString *)fileName {
    if (_fileName == fileName) {
        return;
    }
    _fileName = fileName;
    NSString *path = [[NSBundle mainBundle] pathForResource:_fileName ofType:nil];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
}

- (void)loadCurrentURL {
    NSURL *loadURL = [NSURL URLWithString:self.urlString];
    if (loadURL == nil) {
        loadURL = [NSURL URLWithString:[self.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loadURL];
    [self loadRequest:request];
}

- (void)backAction
{
    [self closeAction];
}

- (void)closeAction
{
    if (self.navigationController != nil && self.navigationController.viewControllers.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)showPopoverView {
    [self showNavigtaionItem];
}

- (void)showNavigtaionItem {
    NSMutableArray *menuList = [NSMutableArray array];
    NSArray *icons = @[@"icon_menu_refresh",@"icon_menu_share"];//,@"icon_menu_service"
    NSArray *names = @[@"刷    新".string,@"分    享".string];//,@"投    诉".string
    for (NSInteger index = 0; index < 3; index++) {
        STMenuInfo *info = [[STMenuInfo alloc]init];
        info.icon = icons[index];
        info.menuName = names[index];
        info.index = index;
        [menuList addObject:info];
    }
    self.popoverView.bounds = CGRectMake(0, 0, 120, (menuList.count > 8 ? 400 : menuList.count * 50));
    self.popoverView.dataArray = menuList;
    __weak typeof(self) weakSelf = self;
    self.popoverView.clickBlock = ^(STMenuInfo * _Nonnull info) {
        if (info.index == 0) {
            [weakSelf loadCurrentURL];
        } else if (info.index == 1) {
            [weakSelf showShareView];
        } else {
            STComplainController *vc = [[STComplainController alloc]init];
            vc.urlString = weakSelf.urlString;
            [weakSelf pushViewController:vc];
            
        }
        [weakSelf.popover dismiss];
    };
    [self.popover show:self.popoverView fromView:self.navtionItem];
}

//分享
- (void)showShareView {
    __weak typeof(self) weakSelf = self;

    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];

    if (self.share.list.count <= 0) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[STSharePlatform createShareName:@"微信" withShareIcon:@"icon_weixin" withScheme:@"weixin://"]];
        [array addObject:[STSharePlatform createShareName:@"QQ" withShareIcon:@"icon_qq" withScheme:@"mqq://"]];
        [array addObject:[STSharePlatform createShareName:@"微博" withShareIcon:@"icon_weibo" withScheme:@"sinaweibo://"]];
        self.shareView.dataArray = array;
    } else {
        self.shareView.dataArray = self.share.list;
    }
    
    [self.shareView show];
    self.shareView.shareClick = ^(STSharePlatform * _Nonnull info) {
        if ([weakSelf.share.type isEqualToString:@"imagetext"] || [weakSelf.share.type isEqualToString:@"text"]) {
            STPwdPopupView *view = [[STPwdPopupView alloc]init];
            [view createSubViewPlatform:info withImageUrl:weakSelf.share.info.image withTextHidden:false];
            [view show];
            view.clickBlock = ^(NSInteger index) {
                if (index == 1) {
                    NSString *text = [NSString stringWithFormat:@"【ConfluxOS】%@「「%@」」复制打开Conflux OS",weakSelf.share.info.url,weakSelf.share.info.desc];
                    [weakSelf callThirdShare:info.scheme withShareTitle:text];
                } else {
                    [weakSelf toSaveImage:weakSelf.share.info.image withShare:info.scheme];
                }
            };
        } else if ([weakSelf.share.type isEqualToString:@"shot"]) {  //截图不+二维码
            STCaptureView *shotView = [[STCaptureView alloc]init];
            [shotView createSubViewPlatform:info withShowView:weakSelf.wkWebView];
            [shotView show];
            shotView.clickBlock = ^(NSInteger index, UIImage *image) {
                if (index == 1) {
                    NSString *text = [NSString stringWithFormat:@"【ConfluxOS】%@「「%@」」复制打开Conflux OS",weakSelf.share.info.url,weakSelf.share.info.desc];
                    [weakSelf callThirdShare:info.scheme withShareTitle:text];
                } else {
                    [weakSelf saveImage:image withShare:info.scheme];
                }
            };
        } else if ([weakSelf.share.type isEqualToString:@"image"]) {
            STPwdPopupView *view = [[STPwdPopupView alloc]init];
            [view createSubViewPlatform:info withImageUrl:weakSelf.share.info.image withTextHidden:true];
            [view show];
            view.clickBlock = ^(NSInteger index) {
                if (index == 1) {
                    NSString *text = [NSString stringWithFormat:@"【ConfluxOS】%@「「%@」」复制打开Conflux OS",weakSelf.share.info.url,weakSelf.share.info.desc];
                    [weakSelf callThirdShare:info.scheme withShareTitle:text];
                } else {
                    [weakSelf toSaveImage:weakSelf.share.info.image withShare:info.scheme];
                }
            };
        } else {
            STShotView *shotView = [[STShotView alloc]init];
            if (weakSelf.share.info == nil) {
                [shotView createSubViewPlatform:info withShowView:weakSelf.wkWebView withTitle:weakSelf.wkWebView.title withDesc:@"" withUrlString:weakSelf.urlString];
            } else {
                [shotView createSubViewPlatform:info withShowView:weakSelf.wkWebView withTitle:weakSelf.share.info.title withDesc:weakSelf.share.info.desc withUrlString:weakSelf.share.info.url];
            }
            [shotView show];
            shotView.clickBlock = ^(NSInteger index, UIImage *image) {
                if (index == 1) {
                    NSString *text = [NSString stringWithFormat:@"【ConfluxOS】%@「「%@」」复制打开Conflux OS",weakSelf.urlString,weakSelf.wkWebView.title];
                    [weakSelf callThirdShare:info.scheme withShareTitle:text];
                } else {
                    [weakSelf saveImage:image withShare:info.scheme];
                }
            };
        }
    };
}


//跳转到微信
- (void)callThirdShare:(NSString *)urlStr withShareTitle:(NSString *)title {
    
    NSURL *url = [NSURL URLWithString:urlStr];

    if([[UIApplication sharedApplication]canOpenURL:url]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.strings = @[title,@""];
        [SVProgressHelper dismissWithMsg:@"口令复制成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
        });
        
    } else {
        [NoticeHelp showSureAlertInViewController:self message:@"没有安装客户端"];
    }
}

- (void)toSaveImage:(NSString *)urlString withShare:(NSString *)shareUrl {
    
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:shareUrl]]) {
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        [self saveImage:img withShare:shareUrl];
    } else {
        [NoticeHelp showSureAlertInViewController:self message:@"没有安装客户端"];
    }

}


- (void)saveImage:(UIImage *)image withShare:(NSString *)shareUrl {
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:shareUrl]]) {
        // 保存图片到相册中
        UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    } else {
        [NoticeHelp showSureAlertInViewController:self message:@"没有安装客户端"];
    }
}

//保存图片完成之后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL) {
        // Show error message…
        [SVProgressHelper dismissWithMsg:@"图片保存失败".string];
    } else {
        // Show message image successfully saved
        __weak typeof(self) weakSelf = self;
        [SVProgressHelper dismissWithMsg:@"图片保存成功".string];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"weixin://"] options:@{} completionHandler:nil];
        });
    }
}

#pragma mark
#pragma mark KINWebBrowserDelegate
- (void)webBrowser:(KINWebBrowserViewController *)webBrowser didStartLoadingURL:(NSURL *)URL{
    
    _urlString = URL.absoluteString;
    [self showLoadingView];
    NSLog(@"show--%@",URL.absoluteString);
    
}
- (void)webBrowser:(KINWebBrowserViewController *)webBrowser didFinishLoadingURL:(NSURL *)URL{
    [self webViewDoNotZoom];
    [self hiddenLoadingView];
    NSLog(@"hidden--%@",URL.absoluteString);
    [self.wkWebView evaluateJavaScript:@"[document.querySelector('img').src,document.title]" completionHandler:^(NSArray *_Nullable resp, NSError * _Nullable error) {
        NSLog(@"%@",resp);
        if (resp.count == 2) {
            [[STCacheManager shareInstance]saveCache:resp.lastObject withUrl:URL.absoluteString withIcon:resp.firstObject];
        } else if (resp.count == 1) {
            NSString *string = resp.firstObject;
            if ([NSString isCheckUrl:string]) {//图片
                [[STCacheManager shareInstance]saveCache:@"" withUrl:URL.absoluteString withIcon:string];
            } else {//标题
                [[STCacheManager shareInstance]saveCache:string withUrl:URL.absoluteString withIcon:@"https://openweb3.oss-cn-shanghai.aliyuncs.com/1717120200358common_placeholder.png"];
            }
        } else {
            [[STCacheManager shareInstance]saveCache:@"" withUrl:URL.absoluteString withIcon:@"https://openweb3.oss-cn-shanghai.aliyuncs.com/1717120200358common_placeholder.png"];
        }
    }];
}

- (void)webBrowser:(KINWebBrowserViewController *)webBrowser didFailToLoadURL:(NSURL *)URL error:(NSError *)error {
    [self hiddenLoadingView];
    if (error.code == NSURLErrorCancelled) {
        return;
    } else if (error.code == 102) {
        [self loadCurrentURL];
        return;
    }
    [self networkErrorNotice];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    });
}

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [self.wkWebView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webBrowserViewControllerWillDismiss:(KINWebBrowserViewController*)viewController{

}

//这里增加手势的返回，不然会被WKWebView拦截
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return true;
}

//关闭调用方法的时候网页会放大
- (void)webViewDoNotZoom {
    NSString *injectionJSString = @"var script = document.createElement('meta');"
                                   "script.name = 'viewport';"
                                   "script.content=\"width=device-width, user-scalable=no\";"
                                   "document.getElementsByTagName('head')[0].appendChild(script);";
    [self.wkWebView evaluateJavaScript:injectionJSString completionHandler:nil];
}

#pragma mark
#pragma mark 原生对 alert confirm textInput
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [SVProgressHelper dismissWithMsg:message];
    completionHandler();
}



- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"%@", prompt);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}


- (BOOL)lxexternalAppRequiredToOpenURL:(NSURL *)URL {
    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https"]];
    return [validSchemes containsObject:URL.scheme];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(webView == self.wkWebView) {
        
        NSURL *URL = navigationAction.request.URL;
        if([self lxexternalAppRequiredToOpenURL:URL]) {
            if(!navigationAction.targetFrame) {
                [self loadURL:URL];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
        }
        else if([[UIApplication sharedApplication] canOpenURL:URL]) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
                
            }];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        if ([URL.absoluteString containsString:@"qqmap"]){
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    STCall *info = [STCall mj_objectWithKeyValues:message.body];
    if ([info.name isEqualToString:@"authUser"]) {//授权用户信息
        NSInteger blockchain = [info.args[@"blockchain"] integerValue];
        NSMutableArray *list = [NSMutableArray array];
        for (STWallet *waller in [[STCacheManager shareInstance] getWallers]) {
            if (waller.blockchain == 32) {
                [list addObject:waller];
            }
        }
        if (list.count <= 0) {
            [SVProgressHelper dismissWithMsg:@"没有可选账号"];
            return;
        }
        self.authorizationView = [[STAuthorization alloc] initWithName:info.name appcode:info.args[@"appcode"] attach:info.attach blockchain:blockchain wallers:list.copy];
        self.authorizationView.delegate = self;
        self.popupViewController = [NoticeHelp showCustomPopViewController:self.authorizationView withGestureDismissal:false complete:nil];
    } else if ([info.name isEqualToString:@"initApp"]) {
        NSString *appCode = [NSString md5:[NSString stringWithFormat:@"%@%@",info.args[@"name"],info.args[@"developer"]]];
        NSString *urlString = [NSString stringWithFormat:@"onAppCallResult(\'{\"name\":\"%@\",\"attach\":\"%@\",\"error\":\"0\",\"result\":{\"appcode\":\"%@\"}}\')",info.name,info.attach,appCode];
        [self.wkWebView evaluateJavaScript:urlString completionHandler:^(id _Nullable resp, NSError * _Nullable error) {
            NSLog(@"%@",resp);
        }];
        
    } else if ([info.name isEqualToString:@"setShareTo"]) {
        self.share.list = [STSharePlatform mj_objectArrayWithKeyValuesArray:info.args[@"list"]];
    } else if ([info.name isEqualToString:@"setShare"]) {
        self.share.info = [STShareInfo mj_objectWithKeyValues:info.args[@"info"]];
    } else if ([info.name isEqualToString:@"toShare"]) {
        self.share.type = info.args[@"type"];
        [self showShareView];
    } else if ([info.name isEqualToString:@"scan"]) {//扫一扫
        STScanViewController *vc = [[STScanViewController alloc] init];
        [self pushViewController:vc];
    } else if ([info.name isEqualToString:@"photo"]) {//相册
        TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 columnNumber:4 delegate:nil];
        vc.allowCrop = true;
        vc.allowPickingVideo = false;
        vc.allowTakePicture = false;
        vc.cropRect = CGRectMake(0, (ScreenHeight - ScreenWidth) * 0.5, ScreenWidth, ScreenWidth);
        vc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (photos.count > 0) {
               
            }
        };
        [self present:vc completion:nil];
        
    }
    NSLog(@"%@---%@",message.name,message.body);
}
#pragma mark - STAuthorizationDelegate
- (void)didSelectedAuthorizationWithReslut:(BOOL)reslut appcode:(NSString *)appcode blockchain:(NSInteger)blockchain wallet:(NSString *)wallet balance:(NSInteger)balance attach:(NSString *)attach name:(NSString *)name {
    [self.popupViewController dismiss:nil];
    if (reslut) {
        NSString *avatar = [STUserDefault objectValueForKey:@"portrait"];
        NSString *displayName = [STUserDefault objectValueForKey:@"displayName"];
        NSString *authCode = [NSString md5:[NSString stringWithFormat:@"%@%@",[STUserDefault objectValueForKey:@"userId"],appcode]];
        NSString *text = [NSString stringWithFormat:@"{\"result\":{\"name\":\"%@\",\"profile\":\"%@\",\"wallet\":\"%@\",\"balance\":\"%ld\",\"authcode\":\"%@\"},\"error\":\"0\",\"attach\":\"%@\",\"name\":\"%@\"}",displayName,avatar,wallet,balance,authCode,attach,name];
        
        [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"onAppCallResult(\'%@\')",text] completionHandler:^(id _Nullable resp, NSError * _Nullable error) {
            NSLog(@"%@",resp);
        }];
    }
}
//c64502252300cbfff2a4fc8c6954cf
#pragma mark
#pragma mark share

- (void)networkErrorNotice
{
    if (self.errorView != nil){
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
    
    [self.view addSubview:self.errorView];
    [self.view bringSubviewToFront:self.errorView];
    [self.view bringSubviewToFront:self.navtionItem];
}

-(void)touchErrorView:(STErrorView *)view{
    if (self.errorView != nil){
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
    [self showLoadingView];
    [self loadCurrentURL];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}


@end
