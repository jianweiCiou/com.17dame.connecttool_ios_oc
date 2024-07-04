//
//  ConnectToolBlack.m
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/1.
//

#import <Foundation/Foundation.h>
#import "ConnectToolBlack.h"
#import "EnumConstants.h"
#import "APIClient.h"
#import "ConnectBasic.h"
#import "WebViewController.h"
#import "Tool.h"
#import "MeInfo.h"
#import "AuthorizeInfo.h"
#import "TestViewController.h"

@implementation ConnectToolBlack


static NSString *redirect_uri = nil;
static NSString *RSAstr = nil;
static NSString *client_id = nil;
static NSString *X_Developer_Id = nil;
static NSString *client_secret = nil;
static NSString *Secret = nil;
static NSString *ClientID = nil;
static NSString *Game_id = nil;
static NSString *requestNumber = nil;
static NSString *notifyUrl = nil;
static NSString *referralCode = @"1688";
static TOOL_VERSION toolVersion = testVS;
static PLATFORM_VERSION platformVersion = nativeVS;

WebViewController *onboardingViewController;
APIClient *apiClient_objc;
UIViewController *rootVC;

NSString *payMethod = @"1";

// Payment
NSString *spCoinItemPriceId = @"";
NSString *prime = @"";
NSString *code = @"";
NSString *access_token = @"";
NSString *refresh_token = @"";
bool *isRunAuthorize = false;

/// 工具初始
/// - Parameters:
///   - _RSAstr: 單位 Key
///   - _client_id: 單位 id
///   - _X_Developer_Id: 開發  id
///   - _client_secret: 單位密鑰
///   - _Game_id: 遊戲 id
///   - _toolVersion: 遊戲 id
///   - _platformVersion: 平台版本
- (instancetype)initWithToolInfo:(NSString *)_RSAstr
                       client_id:(NSString *)_client_id
                  X_Developer_Id:(NSString *)_X_Developer_Id
                   client_secret:(NSString *)_client_secret
                         Game_id:(NSString *)_Game_id
                 platformVersion:(PLATFORM_VERSION)_platformVersion{
    
    self = [super init];
    if (self) {
        [ConnectToolBlack setRSAstr:_RSAstr];
        [ConnectToolBlack setClient_id:_client_id];
        [ConnectToolBlack setX_Developer_Id:_X_Developer_Id];
        [ConnectToolBlack setClient_secret:_client_secret];
        [ConnectToolBlack setSecret:_client_secret];
        [ConnectToolBlack setGame_id:_Game_id];
        [ConnectToolBlack setPlatformVersion:_platformVersion];
        
        
        // 預設為測試
        [ConnectToolBlack setToolVersion:testVS];
        
        payMethod = @"1";
        
        //            payMentBaseurl = @"https://gamar18portal.azurewebsites.net";
        
        // Payment
        spCoinItemPriceId = @"";
        prime = @"";
        code = @"";
        access_token = @"";
        refresh_token = @"";
        payMethod = @"";
        
        //
        apiClient_objc = [[APIClient alloc]init];
        
        if(ConnectToolBlack.toolVersion  == testVS){
            [APIClient setHost: APIClient.host_test];
        }else{
            [APIClient setHost:APIClient.host_release];
        }
        
        self.connectBasic = [[ConnectBasic alloc]
                             initWithClient_id:_client_id
                             X_Developer_Id:_X_Developer_Id
                             client_secret:_client_secret
                             Game_id:_Game_id
                             referralCode: referralCode]; 
        
        // init
        [ConnectToolBlack setRedirect_uri:[NSString stringWithFormat:@"https://%@/Account/connectlink", APIClient.host]];
        [ConnectToolBlack setAccess_token:[[NSUserDefaults standardUserDefaults]stringForKey:@"access_token"]];
        [ConnectToolBlack setRequestNumber:[[NSUUID UUID]UUIDString]];
        
        
        // 初始網頁
        onboardingViewController = [[WebViewController alloc]init];
        [onboardingViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [onboardingViewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
    }
    return self;
}

 

- (void) OpenAuthorizeURL:(NSString *) _state
                   rootVC:(UIViewController *)rootVC{
    NSURL *url = [[NSURL alloc]initWithString:
                  [NSString stringWithFormat:@"https://%@/connect/Authorize?response_type=code&client_id=%@&redirect_uri=%@&scope=game+offline_access&state=%@",
                   APIClient.host,
                   self.connectBasic.client_id,
                   [Tool urlEncoded:ConnectToolBlack.redirect_uri],
                   [Tool urlEncoded:_state]
                  ]];
    [self openhostPage:url rootVC:rootVC];
}

/// 登出
- (void) SwitchAccountURL:(UIViewController *)rootVC {
     
    [onboardingViewController removeWKWebsiteDataStore];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"expiresTs"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"refresh_token"];
    
    [self OpenLoginURL:rootVC];
    
}

- (void) OpenLoginURL:(UIViewController *)rootVC{
    NSURL *url = [self getLoginURL];
    [self openhostPage:url rootVC:rootVC];
}


- (NSURL *) getLoginURL{
//    NSURLComponents *components = [[NSURLComponents alloc]init];
//    [components setScheme:@"https"];
//    [components setHost:APIClient.host];
//    [components setPath:[NSString
//                         stringWithFormat:@"/account/AppLogin/%@/%@",
//                         Game_id,
//                         referralCode]];
//    
//    NSMutableArray * newQueryItems = [NSMutableArray arrayWithCapacity:1 ];
//    [newQueryItems addObject:[[NSURLQueryItem alloc] initWithName:@"returnUrl" value:_redirect_uri]];
//    [components setQueryItems:newQueryItems];
    
//    return components.URL;
    
    
//   登入
        NSString * _redirect_uri = [NSString stringWithFormat:@"%@?accountBackType=Login", ConnectToolBlack.redirect_uri];
    NSURL *url = [[NSURL alloc]initWithString:
                  [NSString stringWithFormat:@"https://%@/account/AppLogin/%@/%@?returnUrl=%@",
                   APIClient.host,
                   Game_id,
                   referralCode,
                   _redirect_uri
                   ]];
    
    // APp 註冊
//    NSString * _redirect_uri = [NSString stringWithFormat:@"%@?accountBackType=Register", ConnectToolBlack.redirect_uri];
//    NSURL *url = [[NSURL alloc]initWithString:
//                  [NSString stringWithFormat:@"https://%@/account/AppRegister/%@/%@?returnUrl=%@&utm_source=xizheng&utm_medium=app&utm_campaign=s1",
//                   APIClient.host,
//                   Game_id,
//                   referralCode,
//                   _redirect_uri
//                   ]];
    
    // 一般頁面註冊
//        NSURL *url = [[NSURL alloc]initWithString:
//                      [NSString stringWithFormat:@"https://%@/Account/Register",
//                       APIClient.host
//                       ]];
    
    return url;
}



/// 開啟儲值頁面
/// - Parameters:
///   - currencyCode:  (說明參考 [here](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#currency-code))
///   - _notifyUrl:  NotifyUrl is a URL customized by the game developer.
///   - state:  (說明參考 [here](https://github.com/jianweiCiou/com.17dame.connecttool_android/blob/main/README.md#open-recharge-page))
- (void) OpenRechargeURL:(NSString*)currencyCode
              _notifyUrl:(NSString*)_notifyUrl
                   state:(NSString*)state
                  rootVC:(UIViewController*)rootVC{
    [self set_purchase_notifyData:notifyUrl state:state];
     
    NSURL *url = [self getRechargeURL:currencyCode _notifyUrl:_notifyUrl state:state];
    
    if ([self isOverExpiresTs]) {
        // token 到期
        [self GetRefreshToken_Coroutine:^(ConnectToken *_token) {
            [self openhostPage:url rootVC:rootVC];
        }];
    } else {
        [self openhostPage:url rootVC:rootVC];
    }
}


- (NSURL *) getRechargeURL:(NSString*)currencyCode
                _notifyUrl:(NSString*)_notifyUrl
                     state:(NSString*)state
{
    NSString *notifyUrl = @"";
    if([_notifyUrl isEqualToString:@""]){
        notifyUrl = @"none_notifyUrl";
    }else{
        notifyUrl = [Tool urlEncoded:_notifyUrl];
    }
    
    NSURL *url = [[NSURL alloc]initWithString:
                  [NSString stringWithFormat:@"https://%@/MemberRecharge/Recharge?X_Developer_Id=%@&accessScheme=%@&accessType=%@&currencyCode=%@&notifyUrl=%@&state=%@&state=referralCode%@",
                   APIClient.host,
                   self.connectBasic.X_Developer_Id,
                   [Tool urlEncoded:ConnectToolBlack.redirect_uri],
                   @"2",
                   currencyCode,
                   notifyUrl,
                   [Tool urlEncoded:state],
                   referralCode
                  ]];
    return url;
}

/**
 * Open ConsumeSP page.
 *
 * @param consume_spCoin - SP Coin
 * @param orderNo        - Must be unique,Game developers customize
 * @param GameName       - GameName
 * @param productName    - Product Name
 * @param _notifyUrl     - <a href="https://github.com/jianweiCiou/com.17dame.connecttool_android/blob/main/README.md#notifyurl--state">NotifyUrl is a URL customized by the game developer. We will post NotifyUrl automatically when the purchase is completed</a>
 * @param state          - <a href="https://github.com/jianweiCiou/com.17dame.connecttool_android/blob/main/README.md#notifyurl--state">State is customized by game developer, which will be returned to game app after purchase complete. (Deeplink QueryParameter => purchase_state)</a>
 * @see <a href="https://github.com/jianweiCiou/com.17dame.connecttool_android/blob/main/README.md#open-consumesp-page">Description</a>
 */
/// 開啟消費頁面
/// - Parameters:
///   - consume_spCoin:  (說明參考
- (void) OpenConsumeSPURL:(NSInteger)consume_spCoin
                  orderNo:(NSString*)orderNo
                 GameName:(NSString*)GameName
              productName:(NSString*)productName
               _notifyUrl:(NSString*)_notifyUrl
                    state:(NSString*)state
            requestNumber:(NSString*)requestNumber
                   rootVC:(UIViewController*)rootVC {
    
    [self set_purchase_notifyData:_notifyUrl state:state];
    
    NSString *_orderNo = orderNo;
    if ([_orderNo isEqual:@""]) {
        _orderNo = [[NSUUID UUID]UUIDString];
    }
    
    NSURL *url = [self getConsumeSPURL:consume_spCoin
                               orderNo:orderNo GameName:GameName
                           productName:productName
                            _notifyUrl:_notifyUrl
                                 state:state
                         requestNumber:requestNumber];
    
    [ConnectToolBlack setRequestNumber:requestNumber];
    [ConnectToolBlack setNotifyUrl:_notifyUrl];
    
    if ([self isOverExpiresTs]) {
        // token 到期
        [self GetRefreshToken_Coroutine:^(ConnectToken *_token) {
            [self openhostPage:url rootVC:rootVC];
        }];
    } else {
        [self openhostPage:url rootVC:rootVC];
    }
}

- (NSURL *) getConsumeSPURL:(NSInteger)consume_spCoin
                    orderNo:(NSString*)orderNo
                   GameName:(NSString*)GameName
                productName:(NSString*)productName
                 _notifyUrl:(NSString*)_notifyUrl
                      state:(NSString*)state
              requestNumber:(NSString*)requestNumber {
    
    // 儲存 SharedPreferences
    [[NSUserDefaults standardUserDefaults] setValue:requestNumber forKey:@"requestNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *notifyUrl = _notifyUrl;
    
    if([_notifyUrl isEqual:@""])
    {
        notifyUrl = @"none_notifyUrl";
    }
    
    NSURL *url = [[NSURL alloc]initWithString:
                  [NSString stringWithFormat:@"https://%@/member/consumesp?xDeveloperId=%@&accessScheme=%@&accessType=%@&gameId=%@&gameName=%@&orderNo=%@&productName=%@&consumeSpCoin=%ld&consumeRebate=%d&notifyUrl=%@&state=%@&referralCode=%@",
                   APIClient.host,
                   self.connectBasic.X_Developer_Id,
                   [Tool urlEncoded:ConnectToolBlack.redirect_uri],
                   @"2",
                   self.connectBasic.Game_id,
                   [Tool urlEncoded:GameName],
                   [Tool urlEncoded:orderNo],
                   [Tool urlEncoded:productName],
                   (long)consume_spCoin,
                   0,
                   [Tool urlEncoded:notifyUrl],
                   [Tool urlEncoded:state],
                   referralCode]];
    
    return url;
}

//====================

/// Set notifyUrl and state. (Optional)
/// - Parameters:
///   - notifyUrl: NotifyUrl is a URL customized by the game developer.
///   - state: (說明參考 [here](https://github.com/jianweiCiou/com.17dame.connecttool_android/blob/main/README.md#open-recharge-page))
- (void) set_purchase_notifyData:(NSString*)notifyUrl
                           state:(NSString*)state{
    //set
    [[NSUserDefaults standardUserDefaults] setValue:notifyUrl forKey:@"purchase_notifyUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:state forKey:@"purchase_state"];
}


/**
 * OpenAuthorize Callback
 *
 * @param notification notification
 * @param _state _state
 * @param GetMe_RequestNumber RequestNumber
 * @param authCallback Callback
 */
- (void) appLinkDataCallBack_OpenAuthorize:(NSNotification*)notification
                                    _state:(NSString*)_state
                       GetMe_RequestNumber:(NSUUID*)GetMe_RequestNumber
                              authCallback:(void (^)(AuthorizeInfo *_token))authCallback{
    
    
    //NSString *code = [[NSUserDefaults standardUserDefaults]stringForKey:@"code"];
    NSString *code = notification.userInfo[@"code"];
    
    [self GetConnectToken_Coroutine:code connectTokenCall:^(ConnectToken *_token) {
        NSString *_access_token = _token.access_token;
        
        [self GetMe_Coroutine:GetMe_RequestNumber callback:^(MeInfo *me) {
            // self.isRunAuthorize = false;
            AuthorizeInfo *_auth = [[AuthorizeInfo alloc]initWithClient_id:me connectToken:_token state:_state access_token:_access_token];
            
            authCallback(_auth);
        }];
        
    }];
}


- (void) GetConnectToken_Coroutine:(NSString*)_code
                  connectTokenCall:(void (^)(ConnectToken *_token))connectTokenCall{
    [APIClient getConnectToken:self connectBasic:self.connectBasic _code:_code redirect_uri:ConnectToolBlack.redirect_uri connectTokenCall:^(ConnectToken * _Nonnull tokenData) { 
        
        connectTokenCall(tokenData);
    }];
    
}

/**
 * Get MeInfo
 *
 * @param _GetMeRequestNumber - App-side-RequestNumber(UUID)
 * @param callback            -
 * @see <a href="https://github.com/jianweiCiou/com.17dame.connecttool_android/blob/main/README.md#query-consumesp-by-transactionid">說明</a>
 */
- (void) GetMe_Coroutine:(NSUUID*)_GetMeRequestNumber
                callback:(void (^)(MeInfo *me))callback{
    
    if ([self isOverExpiresTs]) {
        // 無 token
        // token 到期
        [self GetRefreshToken_Coroutine:^(ConnectToken *_token) {
            [self getMeData:_GetMeRequestNumber callbackMeInfo:^(MeInfo *me) {
                callback(me);
            }];
        }];
    } else {
        [self getMeData:_GetMeRequestNumber callbackMeInfo:^(MeInfo *me) {
            callback(me);
        }];
    }
}

// APIClient
- (void) getMeData:(NSUUID*)_GetMeRequestNumber
    callbackMeInfo:(void (^)(MeInfo *me))callbackMeInfo{
    
    [APIClient getMe:self X_Developer_Id:self.connectBasic.X_Developer_Id RequestNumber:[_GetMeRequestNumber UUIDString] GameId:self.connectBasic.Game_id ReferralCode:referralCode callbackMeInfo:^(MeInfo * _Nonnull _token) {
        callbackMeInfo(_token);
    }];
    
}

- (Boolean) isOverExpiresTs{
    NSString *expiresTs = [[NSUserDefaults standardUserDefaults]stringForKey:@"expiresTs"];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]stringForKey:@"access_token"];
    NSString *refresh_token = [[NSUserDefaults standardUserDefaults]stringForKey:@"refresh_token"];
    
    
    if ([expiresTs isEqual:@""] || [access_token isEqual:@""] || [refresh_token isEqual:@""]) {
        return true;
    } else {
        double expiresTsDouble = [expiresTs floatValue];
        
//        NSDate *date = [NSDate date];
        NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
        double currentTs = ti  ;
         
        if (currentTs > expiresTsDouble) {
//            NSLog(@"到期了");
            return true;
        } else {
//            NSLog(@"還沒到期時間");
            return false;
        }
    }
}

- (void) GetRefreshToken_Coroutine:(void (^)(ConnectToken *_token))connectTokenCall{
    
    if (![self _checkConstructorParametersComplete] ) {
        return;
    }
    
    NSString *refresh_token = [[NSUserDefaults standardUserDefaults]stringForKey:@"refresh_token"];
    
    [APIClient getRefreshTokenData:self connectBasic:self.connectBasic refresh_token:refresh_token redirect_uri:ConnectToolBlack.redirect_uri  connectTokenCall:^(ConnectToken *   tokenData) {
        
        NSString * access_token = tokenData.access_token;
        NSString * refresh_token = tokenData.refresh_token;
        
        // 儲存時間
        [Tool saveExpiresTs:tokenData.expires_in];
        
        // 儲存tokeen
        [[NSUserDefaults standardUserDefaults] setValue:access_token forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setValue:refresh_token forKey:@"refresh_token"];
        
        
        connectTokenCall(tokenData);
    }];
}


- (Boolean) _checkConstructorParametersComplete{
    if ([ConnectToolBlack.redirect_uri isEqual:@""]) {
        return false;
    }
    if ([ConnectToolBlack.RSAstr isEqual:@""]) {
        return false;
    }
    if ([self.connectBasic.X_Developer_Id isEqual:@""]) {
        return false;
    }
    if ([self.connectBasic.client_secret isEqual:@""]) {
        return false;
    }
    if ([self.connectBasic.Game_id isEqual:@""]) {
        return false;
    }
    return true;
}


- (void) openhostPage:(NSURL *)url
               rootVC:(UIViewController *)_rootVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        // init webview
        rootVC = _rootVC;
        [rootVC presentViewController:onboardingViewController animated:true completion:nil];
        
        [onboardingViewController openURLPage:url];
    });
}


/** SET   */
+ (void)setRedirect_uri:(NSString*)newredirect_uri{
    redirect_uri = newredirect_uri;
}
+ (void)setRSAstr:(NSString*)newRSAstr{
    if(!RSAstr) {
        RSAstr = newRSAstr;
    }
}
+ (void)setClient_id:(NSString*)newclient_id{
    if(!client_id) {
        client_id = newclient_id;
    }
    if(!ClientID) {
        ClientID = newclient_id;
    }
}
+ (void)setX_Developer_Id:(NSString*)newX_Developer_Id{
    if(!X_Developer_Id) {
        X_Developer_Id = newX_Developer_Id;
    }
}
+ (void)setClient_secret:(NSString*)newclient_secret{
    if(!client_secret) {
        client_secret = newclient_secret;
    }
}
+ (void)setSecret:(NSString*)newclient_secret{
    if(!Secret) {
        Secret = newclient_secret;
    }
}
+ (void)setGame_id:(NSString*)newGame_id{
    if(!Game_id) {
        Game_id = newGame_id;
    }
}
+ (void)setAccess_token:(NSString*)newaccess_token{
    if(!access_token) {
        access_token = newaccess_token;
    }
}
+ (void)setRequestNumber:(NSString*)newrequestNumber{
    requestNumber = newrequestNumber;
}
+ (void)setNotifyUrl:(NSString*)newnotifyUrl{
    notifyUrl = newnotifyUrl;
}
+ (void)setPlatformVersion:(PLATFORM_VERSION)newplatformVersion{
    platformVersion = newplatformVersion;
}
+ (void)setToolVersion:(TOOL_VERSION)newtoolVersion{
    toolVersion = newtoolVersion;
    
    if (newtoolVersion == testVS) {
        [APIClient setHost:APIClient.host_test ];
        [APIClient setGame_api_host:APIClient.game_api_host_test];
    } else {
        [APIClient setHost:APIClient.host_release ];
        [APIClient setGame_api_host:APIClient.game_api_host_release];
        
        [ConnectToolBlack setRedirect_uri:[NSString stringWithFormat:@"https://%@/Account/connectlink", APIClient.host]];
    }
    
}

/** GET   */
+ (TOOL_VERSION)toolVersion{
    return toolVersion;
}
+ (PLATFORM_VERSION)platformVersion{
    return platformVersion;
}
+ (NSString*)Secret{
    return Secret;
}
+ (NSString*)ClientID{
    return ClientID;
}
+ (NSString*)Game_id{
    return Game_id;
}
+ (NSString*)_me{
    return ConnectToolBlack._me;
}
+ (NSString*)access_token{
    return access_token;
}
+ (NSString*)RSAstr{
    return RSAstr;
}
+ (NSString*)requestNumber{
    return requestNumber;
}
+ (NSString*)notifyUrl{
    return notifyUrl;
}
+ (NSString*)redirect_uri{
    return redirect_uri;
}
+ (NSString*)referralCode{
    return referralCode;
}
@end
