//
//  STWebViewController.h
//  Swim
//
//  Created by YY on 2022/3/11.
//

#import "KINWebBrowserViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

typedef void(^STLoadWebViewBlock)(void);
typedef void(^STSetWebViewBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface STWebViewController : KINWebBrowserViewController <KINWebBrowserDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebViewConfiguration *configuration;

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) WKWebView *webView;

- (void)showLoadingView;

- (void)hiddenLoadingView;

- (void)loadCurrentURL;

@end

NS_ASSUME_NONNULL_END
