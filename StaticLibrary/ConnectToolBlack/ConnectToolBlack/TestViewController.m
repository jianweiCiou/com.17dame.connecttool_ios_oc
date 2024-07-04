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
}

#pragma mark - Private Methods
- (void)setup {
    [self setupWebView];
}


- (void)setupWebView {
    self.webView = [[WKWebView alloc] initWithFrame: CGRectZero
                                      configuration: [self setJS]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview: self.webView];
}

// 開頁面
- (void)openURLPage:(NSURL *)url { 
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url
                                                  cachePolicy: NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval: 5];
    [self.webView loadRequest: request];
     
}

- (WKWebViewConfiguration *)setJS {
    NSString *jsString = @"";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource: jsString
                                                      injectionTime: WKUserScriptInjectionTimeAtDocumentEnd
                                                   forMainFrameOnly:YES];
    WKUserContentController *wkUController = [WKUserContentController new];
    [wkUController addUserScript: userScript];
    
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
 



#pragma mark - WKNavigationDelegate

#pragma mark -
//
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURLRequest *request = navigationAction.request;
    NSString *hostname = request.URL.host.lowercaseString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && ![hostname containsString:@"baidu.com"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
 
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
}

#pragma mark - WKNavigationDelegate
 
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
}
 
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    //_progressView.hidden = true;
}
 
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
     
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}
 
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
}

#pragma mark - WKScriptMessageHandler js
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
