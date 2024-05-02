//
//  TestViewController.m
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/7.
//
 
#import "TestViewController.h"
#import <WebKit/WebKit.h>

@interface TestViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic) WKWebView *webView;
@end

static NSString *const RequestURL = @"https://www.apple.com/";


@implementation TestViewController

#pragma mark - LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setup];
    
//    WKUserContentController *userC = [[WKUserContentController alloc] init];
//        [userC addScriptMessageHandler:self name:@"showMsg"];
//        [userC addScriptMessageHandler:self name:@"selectPicture"];
//        [userC addScriptMessageHandler:self name:@"postClick"];
//        
//        WKPreferences *preference = [WKPreferences new];
//        preference.minimumFontSize = 10;
//        preference.javaScriptCanOpenWindowsAutomatically = true;
//        
//        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
//        config.userContentController = userC;
//        config.preferences = preference;
//    
//        self.webView = [[WKWebView alloc] initWithFrame:self.view.frame  configuration:config];
//    self.webView.UIDelegate = self;
//    self.webView.navigationDelegate = self;
//    
//    
//    self.webView.translatesAutoresizingMaskIntoConstraints = false;
//    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
//    
//    
//    [self setURL: RequestURL];
//    
//    [self.view addSubview: self.webView];
    
      
}

#pragma mark - Private Methods
- (void)setup {
    [self setupWebView];
//    [self setURL: RequestURL];
}


- (void)setupWebView {
    self.webView = [[WKWebView alloc] initWithFrame: CGRectZero
                                      configuration: [self setJS]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview: self.webView];
//    [self setupWKWebViewConstain: self.webView];
}

// 開頁面
- (void)openURLPage:(NSURL *)url { 
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url
                                                  cachePolicy: NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval: 5];
    [self.webView loadRequest: request];
     
}

/// JSをセット（生成時に仕込み。JS側でトリガーする）
- (WKWebViewConfiguration *)setJS {
    NSString *jsString = @"";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource: jsString
                                                      injectionTime: WKUserScriptInjectionTimeAtDocumentEnd
                                                   forMainFrameOnly:YES];
    WKUserContentController *wkUController = [WKUserContentController new];
    [wkUController addUserScript: userScript];
    // JSを判別するためのキーを設定
    [wkUController addScriptMessageHandler:self name:@"callbackHandler"];
    
    WKWebViewConfiguration *wkWebConfig = [WKWebViewConfiguration new];
    wkWebConfig.userContentController = wkUController;
    
    return wkWebConfig;
}



- (void)setURL:(NSString *)requestURLString {
    NSURL *url = [[NSURL alloc] initWithString: requestURLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url
                                                  cachePolicy: NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval: 5];
    [self.webView loadRequest: request];
}
 



#pragma mark - WKNavigationDelegate 页面跳转和载入

#pragma mark - 页面跳转
//收到跳转动作时, 决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURLRequest *request = navigationAction.request;
    NSString *hostname = request.URL.host.lowercaseString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && ![hostname containsString:@"baidu.com"]) {
        // 对于跨域，需要手动跳转
//        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    NSLog(@"收到跳转动作时, 决定是否跳转");
}
//收到服务器响应时, 决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"收到服务器响应时, 决定是否跳转");
}

//收到服务器跳转动作时, 决定是否跳转
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"收到服务器跳转动作时, 决定是否跳转");
}

#pragma mark - WKNavigationDelegate 页面载入

// 开始请求内容
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"开始请求内容");
}

// 开始请求内容时失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"开始请求内容时失败");
}

// 服务器开始返回内容
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"服务器开始返回内容");
}

// 服务器开始返回内容完毕
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"服务器开始返回内容完毕");
//    _progressView.hidden = true;
}

// 服务器开始返回内容过程错误
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@" 服务器开始返回内容过程错误");
    //_progressView.hidden = true;
}

// 页面权限变化
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    NSLog(@"页面权限变化时处理");
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

// 服务器开始返回内容过程终止
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"服务器开始返回内容过程终止");
}

#pragma mark - WKScriptMessageHandler js 调用 OC 接口
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"showMsg"]) {
        //[self showMsg:message.body];
    } else if ([message.name isEqualToString:@"selectPicture"]) {
        //[self selectPicture];
    }else if ([message.name isEqualToString:@"postClick"]) {
       // [self postClick:message.body];
    }
    
}

 
@end
