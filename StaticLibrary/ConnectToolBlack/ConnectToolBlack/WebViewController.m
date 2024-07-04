//
//  WebViewController.m
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "MeInfo.h"
#import "ConnectToolBlack.h"
#import "APIClient.h"
#import "ConnectBasic.h"
#import "Tool.h"

@interface WebViewController () <WKUIDelegate, WKNavigationDelegate,UINavigationBarDelegate, WKScriptMessageHandler>
@property (nonatomic) WKWebView *webView;
@end

@implementation WebViewController

NSString *sendFinish_funcName = @"sendFinish";
NSString *observeValueURL = @"";

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
    self.webView = [[WKWebView alloc] initWithFrame: [[self view] bounds] configuration: [self setJS]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    // Add observer
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview: self.webView];
    [self setupWKWebViewConstain: self.webView];
    
    [self addNavigationBar];
}

- (void) addNavigationBar{
     
}

-(void)dismissViewController:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)onTapCancel:(UIBarButtonItem*)item{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    id key = change[NSKeyValueChangeNewKey];
    if (key) {
        observeValueURL = [NSString stringWithFormat:@"%@",key];
        if (![observeValueURL isEqual:@""]){
            [self cURLChange:observeValueURL];  // Pass key-value to function
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)cURLChange:(  NSString *)url{
    // Oauth 回應
    if ([observeValueURL containsString:@"Account/connectlink"]){
        
        NSString * accountBackType = [self getQueryComponentWithName:@"accountBackType" fromURL:[NSURL URLWithString:url]];
        
        if (![accountBackType isEqual:@""]){
            // auth
            if ([accountBackType isEqual:@"Register"]){
                NSDictionary *backTypeResponse = @{@"accountBackType": @"Register"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"r17dame_ReceiverCallback" object:nil userInfo:backTypeResponse];
                
                [self finishWebPage];
            }
            if ([accountBackType isEqual:@"Login"]){
                NSDictionary *backTypeResponse = @{@"accountBackType": @"Login"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"r17dame_ReceiverCallback" object:nil userInfo:backTypeResponse];
                
                [self finishWebPage];
            }
            
        }
        
        NSString * code = [self getQueryComponentWithName:@"code" fromURL:[NSURL URLWithString:url]];
        
        if (code){
            NSDictionary<NSString *, NSString *> *backTypeResponse = @{@"accountBackType": @"Authorize",@"code": code};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"r17dame_ReceiverCallback" object:nil userInfo:backTypeResponse];
            
            [self finishWebPage];
        }
        
    }
}

- (void) finishWebPage {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)removeWKWebsiteDataStore{
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore
     fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
        for (WKWebsiteDataRecord *record  in records) {
            [[WKWebsiteDataStore defaultDataStore]
             removeDataOfTypes:record.dataTypes
             forDataRecords:@[record]
             completionHandler:^{
                NSLog(@"Cookies for %@ deleted successfully",record.displayName);
            }
            ];
        }
    }
    ];
}
- (NSString *)getQueryComponentWithName:(NSString *)name  fromURL:(NSURL *)url{
    
    NSString *component = nil;
    if (url) {
        NSString *query = url.query;
        
        NSMutableDictionary *queryStringDictionary = [NSMutableDictionary dictionary];
        NSArray *urlComponents = [query componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents){
            
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
            
            [queryStringDictionary setObject:value forKey:key];
        }
        
        component = [queryStringDictionary objectForKey:name];
    }
    return component;
}


- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"URL"];
}

// 開頁面
- (void)openURLPage:(NSURL *)url {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url
                                                  cachePolicy: NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval: 15];
    [self.webView loadRequest: request];
}

- (WKWebViewConfiguration *)setJS {
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = true;
    
    WKUserContentController *wkUController = [WKUserContentController new];
    
    // cookies
    NSMutableString  *cookies  = [NSMutableString string];
    WKUserScript * cookieScript  = [[WKUserScript alloc] initWithSource:[cookies copy]
                                                          injectionTime: WKUserScriptInjectionTimeAtDocumentStart
                                                       forMainFrameOnly:YES];
    [wkUController addUserScript: cookieScript];
    
    //
    [wkUController addScriptMessageHandler:self name:@"iOS17dame"];
    [wkUController addScriptMessageHandler:self name:@"sendFinish"];
    [wkUController addScriptMessageHandler:self name:@"CompleteLogin"];
    [wkUController addScriptMessageHandler:self name:@"CompleteRegistration"];
    [wkUController addScriptMessageHandler:self name:@"locationHref"];
    [wkUController addScriptMessageHandler:self name:@"runSPCoinCreateOrder"];
    [wkUController addScriptMessageHandler:self name:@"getXSignature"];
    [wkUController addScriptMessageHandler:self name:@"PayWithBindPrime"];
    [wkUController addScriptMessageHandler:self name:@"appLinkDataCallBack_CompletePurchase"];
    [wkUController addScriptMessageHandler:self name:@"appLinkDataCallBack_CompleteConsumeSP"];
    [wkUController addScriptMessageHandler:self name:@"iosListener"];
    //************************************************************************
    
    // localStorageData
    NSError *error;
    NSData *meData = [[NSUserDefaults standardUserDefaults] objectForKey:@"me"];
    
    if(meData != nil){
        
        if (error) {
            NSLog(@"Got an error: %@", [error localizedDescription]);
        }
        NSMutableDictionary *metionary = (NSMutableDictionary*)[NSKeyedUnarchiver
                                                                unarchivedObjectOfClasses:
                                                                    [NSSet setWithArray:@[
                                                                        NSString.class,
                                                                        NSNumber.class,
                                                                        NSNull.class,
                                                                        NSDictionary.class]]
                                                                fromData:meData
                                                                error:&error ];
        
        NSString *meJsonString;
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:metionary
                            options:NSJSONWritingPrettyPrinted
                            error:&error];
        if (! jsonData) {
            //            NSLog(@"Got an error: %@", error);
        } else {
            meJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        // meData
        [wkUController addUserScript: [[WKUserScript alloc]
                                       initWithSource: [NSString stringWithFormat:@"Object.assign(window.localStorage, %@);",[NSJSONSerialization dataWithJSONObject:@{@"me":meJsonString} options:0 error:nil]]
                                       injectionTime: WKUserScriptInjectionTimeAtDocumentStart
                                       forMainFrameOnly:YES]];
    }
    
    NSMutableDictionary *localStorageData = [[NSMutableDictionary alloc]initWithCapacity:1];
    [localStorageData setObject:ConnectToolBlack.RSAstr forKey:@"RSAstr"];
    [localStorageData setObject:ConnectToolBlack.Secret forKey:@"Secret"];
    [localStorageData setObject:ConnectToolBlack.ClientID forKey:@"ClientID"];
    NSData *dataRecvd = [NSJSONSerialization dataWithJSONObject:localStorageData options:kNilOptions error:&error];
    if(!dataRecvd && error){
        //            NSLog(@"Error creating JSON: %@", [error localizedDescription]);
    }
    NSString *value = [[NSString alloc] initWithData:dataRecvd encoding:NSUTF8StringEncoding];
    NSString *js = [NSString stringWithFormat:@"Object.assign(window.localStorage, %@);",value];
    //        NSLog(@"js ：%@", js);
    [wkUController addUserScript: [[WKUserScript alloc]
                                   initWithSource: js
                                   injectionTime: WKUserScriptInjectionTimeAtDocumentStart
                                   forMainFrameOnly:YES]];
    
    // 增加頁面 log
    NSString *source = @"document.addEventListener('message', function(e){ window.webkit.messageHandlers.iosListener.postMessage(e.data); })";
    [wkUController addUserScript: [[WKUserScript alloc]
                                   initWithSource: source
                                   injectionTime: WKUserScriptInjectionTimeAtDocumentEnd
                                   forMainFrameOnly:YES]];
    //************************************************************************
    
    WKWebViewConfiguration *wkWebConfig = [WKWebViewConfiguration new];
    wkWebConfig.userContentController = wkUController;
    
    WKWebpagePreferences *webpagePreferences = [[WKWebpagePreferences alloc] init];
    webpagePreferences.allowsContentJavaScript = YES;
    wkWebConfig.defaultWebpagePreferences = webpagePreferences;
    //    if (@available(iOS 14.0, *)) {
    //
    //    }else{
    //        preferences.javaScriptEnabled = YES;
    //    }
    
    wkWebConfig.preferences = preferences;
    //************************************************************************
    
    
    return wkWebConfig;
}

///
- (void)triggerJS:(NSString *)jsString webView:(WKWebView *)webView {
    
    [webView evaluateJavaScript:jsString
              completionHandler:^(NSString *result, NSError *error){
        if (error != nil) {
            return;
        }
    }];
}

///
- (void)setupWKWebViewConstain: (WKWebView *)webView {
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [webView.topAnchor constraintEqualToAnchor:safe.topAnchor constant:0],
        [webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor ],
        [webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor ],
        [webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor ],
    ]];
}


#pragma mark - UIWebViewDelegate Methods
///
- (WKWebView *)webView:(WKWebView *)webView
createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
   forNavigationAction:(WKNavigationAction *)navigationAction
        windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (navigationAction.targetFrame != nil &&
        !navigationAction.targetFrame.mainFrame) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [[NSURL alloc] initWithString: navigationAction.request.URL.absoluteString]];
        [webView loadRequest: request];
        
        return nil;
    }
    return nil;
}

///
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

///
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

///
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
}

#pragma mark - WKNavigationDelegate Methods
///
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //    NSLog(@"読み込み完了");
    
    NSString *access_token = [[NSUserDefaults standardUserDefaults]valueForKey:@"access_token"];
    
    [self triggerJS:[NSString stringWithFormat:@"javascript:localStorage.setItem('Secret', '%@');",ConnectToolBlack.Secret] webView:webView];
    [self triggerJS:[NSString stringWithFormat:@"javascript:localStorage.setItem('ClientID', '%@');",ConnectToolBlack.ClientID] webView:webView];
    [self triggerJS:[NSString stringWithFormat:@"javascript:localStorage.setItem('access_token', '%@');",access_token] webView:webView];
    [self triggerJS:[NSString stringWithFormat:@"javascript:localStorage.setItem('requestNumber', '%@');",ConnectToolBlack.requestNumber] webView:webView];
    [self triggerJS:[NSString stringWithFormat:@"javascript:localStorage.setItem('redirect_uri', '%@');",ConnectToolBlack.redirect_uri] webView:webView];
    [self triggerJS:[NSString stringWithFormat:@"javascript:localStorage.setItem('referralCode', '%@');",ConnectToolBlack.referralCode] webView:webView];
    [self triggerJS:[NSString stringWithFormat:@"javascript:localStorage.setItem('notifyUrl', '%@');",ConnectToolBlack.notifyUrl] webView:webView];
     
    //************************************************************************
    
    
    NSString *url = webView.URL.absoluteString;
    
    // 設定遊戲註冊
    if ([url containsString:@"/Account/Login"]) {
        
        NSString *AppRegisterUrl =
        [NSString stringWithFormat:@"'/account/AppRegister/%@/%@?returnUrl=%@&accountBackType=Register'",
         ConnectToolBlack.Game_id,
         ConnectToolBlack.referralCode,
         [Tool urlEncoded:ConnectToolBlack.redirect_uri]
        ];
        
        NSString *script = [NSString stringWithFormat:@"javascript:(function(){document.getElementById('goToRegister').href=%@;})()",AppRegisterUrl];
        [self triggerJS:script webView:webView];
    }
}
 
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
}

// 接続失敗
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error { 
}

#pragma mark - WKScriptMessageHandler Methods
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if([message.name  isEqual: @"sendFinish"]) {
        //關閉頁面
        [self finishWebPage];
    }
    
    /**
     * 註冊結束
     */
    if([message.name isEqual: @"CompleteRegistration"]) {
        NSString * _messageString = [NSString stringWithFormat:@"%@",message.body];
        if([_messageString isEqual:@"CompleteRegistration"]){
            
            // 完成註冊
            [self WebViewOpenAuthorizeURL];
        }else{
            //            NSLog(@"註冊失敗：%@", _messageString);
        }
    }
    
    if([message.name  isEqual: @"CompleteLogin"]) {
        //關閉頁面
        [self WebViewOpenAuthorizeURL];
    }
    
    
    // 消費
    if([message.name  isEqual: @"appLinkDataCallBack_CompleteConsumeSP"]) {
        
        NSString * _messageString = [NSString stringWithFormat:@"%@",message.body];
        
        NSData *data = [_messageString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSMutableDictionary *backTypeResponse = [[NSMutableDictionary alloc]initWithCapacity:1];
        [backTypeResponse setObject:@"CompleteConsumeSP" forKey:@"accountBackType"];
        [backTypeResponse setObject:json forKey:@"CompleteConsumeSP"];
        [backTypeResponse setObject:[[json objectForKey:@"data"]objectForKey:@"transactionId"] forKey:@"consume_transactionId"];
        [backTypeResponse setObject:[[json objectForKey:@"data"]objectForKey:@"orderStatus"] forKey:@"consume_status"];
        [backTypeResponse setObject:[[json objectForKey:@"data"]objectForKey:@"transactionId"] forKey:@"transactionId"];
        [backTypeResponse setObject:[[json objectForKey:@"data"]objectForKey:@"orderNo"] forKey:@"orderNo"];
        [backTypeResponse setObject:[[json objectForKey:@"data"]objectForKey:@"productName"] forKey:@"productName"];
        [backTypeResponse setObject:[[json objectForKey:@"data"]objectForKey:@"spCoin"] forKey:@"spCoin"];
        [backTypeResponse setObject:[[json objectForKey:@"data"]objectForKey:@"rebate"] forKey:@"rebate"];
        [backTypeResponse setObject:[[json objectForKey:@"data"]objectForKey:@"orderStatus"] forKey:@"orderStatus"];
        [backTypeResponse setObject:[[json objectForKey:@"data"]objectForKey:@"state"] forKey:@"state"];
        [backTypeResponse setObject:[[json objectForKey:@"data"]objectForKey:@"notifyUrl"] forKey:@"notifyUrl"];
        
        //        NSLog(@"backTypeResponse json：%@", backTypeResponse);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"r17dame_ReceiverCallback" object:nil userInfo:backTypeResponse];
        
        [self finishWebPage];
    }
    
    
    // 購買
    if([message.name  isEqual: @"appLinkDataCallBack_CompletePurchase"]) {
        
        NSString *PurchaseMessage = [NSString stringWithFormat:@"%@",message.body];
        NSArray *fullPurchaseArr = [PurchaseMessage componentsSeparatedByString:@","];
        
        NSString *state = fullPurchaseArr[0];
        NSString *TradeNo = fullPurchaseArr[1];
        NSString *PurchaseOrderId = fullPurchaseArr[2];
        
        NSMutableDictionary *backTypeResponse = [[NSMutableDictionary alloc]initWithCapacity:1];
        [backTypeResponse setObject:@"CompletePurchase" forKey:@"accountBackType"];
        [backTypeResponse setObject:state forKey:@"state"];
        [backTypeResponse setObject:TradeNo forKey:@"TradeNo"];
        [backTypeResponse setObject:PurchaseOrderId forKey:@"PurchaseOrderId"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"r17dame_ReceiverCallback" object:nil userInfo:backTypeResponse];
        
        [self finishWebPage];
    }
}


-(void) WebViewOpenAuthorizeURL{
    NSString * _state = [[NSUUID UUID]UUIDString];
    
    NSURL *url = [[NSURL alloc]initWithString:
                  [NSString stringWithFormat:@"https://%@/connect/Authorize?response_type=code&client_id=%@&redirect_uri=%@&scope=game+offline_access&state=%@",
                   APIClient.host,
                   ConnectToolBlack.ClientID,
                   [Tool urlEncoded:ConnectToolBlack.redirect_uri],
                   _state
                  ]];
    [self openURLPage:url];
}

@end
