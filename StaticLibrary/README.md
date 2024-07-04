# 17dame connecttool static libary

此版本為 17dame connecttool 的靜態庫，Architectures 為 x86_64, arm64 

## Table of Contents  
- [安裝](#安裝) 
- [Setting](#setting)
    - [加入 ConnectToolConfig](#加入-connecttoolconfig)
- [VC 佈局](#viewcontroller-佈局)
    - [ConnectTool 初始](#connecttool-初始)
- [發行版本切換](#發行版本切換)
- [登入 / 註冊](#登入--註冊)
    - [範例](#呼叫範例)
    - [參考](#參考)
- [取得用戶資訊](#取得用戶資訊)
    - [範例](#呼叫範例-1) 
- [儲值 SP](#儲值-sp)
    - [範例](#呼叫範例-2) 
    - [儲值 SP 測試用資料](#儲值-sp-測試用資料) 
    - [參考](#參考-1)
- [消費 SP](#消費-sp)
    - [範例](#呼叫範例-3)
    - [消費說明](#開啟頁面)
- [遊戲 Server 端驗證方式](#遊戲-server-端驗證方式)
  
## 安裝
-  下載靜態庫檔案
[click to download](https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/StaticLibrary/ConnectToolBlackOutput.zip)

-  將其資料夾直接拖拉進專案
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/StaticLibrary/images/Draglib.jpg" width="500">
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/StaticLibrary/images/Draglib2.jpg" width="500"> 
-  完成安裝
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/StaticLibrary/images/Draglib4.jpg" width="300"> 
-  並在 Target 中的 Build Phases 中, 確認 Link Binary With Libraries 有引入 libConnectToolBlack.a

## Setting   
### 加入 ConnectToolConfig
- Add ConnectToolConfig.xcconfig to Project 
- File > New > File > Configurations > Debug & Release
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios/blob/main/images/add_config.png?raw=true" width="600">

- 命其名為 : ConnectToolConfig

- 進 Project 進行配置
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios/blob/main/images/set_config.png?raw=true" width="600">

- 填入對應資料
```txt
X_Developer_Id = 
client_secret =  
Game_id = 
```

- Info.plist 增加數據
```XML 
    <key>X_Developer_Id</key>
    <string>$(X_Developer_Id)</string>
    <key>client_secret</key>
    <string>$(client_secret)</string> 
    <key>Game_id</key>
    <string>$(Game_id)</string>  
```
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios/blob/main/images/plist.png?raw=true" width="600">

## ViewController 佈局
### ConnectTool 初始
- 工具初始
- 設定測試與正式
- 註冊 17dame NotificationCenter 應用事件
```objc 
#import "ViewController.h"
#import "include/ConnectToolBlack/ConnectToolBlack.h"
``` 
```objc 
@implementation ViewController

ConnectToolBlack *_connectTool;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 工具初始
    NSString *RSAstr = @"..."; 
    
    NSString *X_Developer_Id = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"X_Developer_Id"];
    NSString *client_secret = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"client_secret"];
    NSString *Game_id = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Game_id"];
    
    _connectTool = [[ConnectToolBlack alloc]
                    initWithToolInfo:RSAstr
                    client_id:X_Developer_Id
                    X_Developer_Id:X_Developer_Id
                    client_secret:client_secret
                    Game_id:Game_id
                    platformVersion:nativeVS];
    
    // 切換測試與正式
     [ConnectToolBlack setToolVersion:testVS]; // 測試
    // [ConnectToolBlack setToolVersion:releaseVS]; // 正式
    
    
    // 註冊 17dame 應用事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(r17dame_ReceiverCallback:)
                                                 name:@"r17dame_ReceiverCallback"
                                               object:nil];
}
```

- 移除 17dame 應用事件的訂閱
```objc 
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"r17dame_ReceiverCallback" object:nil];
}
```

- 17dame 應用事件回應 : 完成登入, 完成註冊, 完成儲值, 完成消費
```objc
/// 17dame 應用事件回應
- (void) r17dame_ReceiverCallback:(NSNotification *) notification
{
    NSDictionary *dict = notification.userInfo;
    NSString *backType = [dict valueForKey:@"accountBackType"];

    // 完成儲值
    if ([backType isEqualToString:@"CompletePurchase"]){
        NSLog(@"完成儲值");
        NSLog(@"TradeNo :%@" , [dict valueForKey:@"TradeNo"]);
        NSLog(@"PurchaseOrderId :%@" , [dict valueForKey:@"PurchaseOrderId"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.orderNo setText:[dict valueForKey:@"TradeNo"]];
        });
        
        // 更新 me
        [self GetMe_Coroutine];
    }
    
    // Complete consumption of SP Coin 完成消費 SP
    if ([backType isEqualToString:@"CompleteConsumeSP"]){
        NSLog (@"CompleteConsumeSP");
        
        //完成消費 SP
        NSLog(@"完成消費");
        NSLog(@"consume_status :%@" , [dict valueForKey:@"consume_status"]);
        NSLog(@"transactionId :%@" , [dict valueForKey:@"transactionId"]);
        NSLog(@"orderNo :%@" , [dict valueForKey:@"orderNo"]);
        NSLog(@"productName :%@" , [dict valueForKey:@"productName"]);
        NSLog(@"spCoin :%@" , [dict valueForKey:@"spCoin"]);
        NSLog(@"rebate :%@" , [dict valueForKey:@"rebate"]);
        NSLog(@"orderStatus :%@" , [dict valueForKey:@"orderStatus"]);
        NSLog(@"state :%@" , [dict valueForKey:@"state"]);
        NSLog(@"notifyUrl :%@" , [dict valueForKey:@"notifyUrl"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.txID setText:[dict valueForKey:@"transactionId"]];
        });
        
        // 更新 me
        [self GetMe_Coroutine];
    }
    
    // 登入
    if ([backType isEqualToString:@"Authorize"]){
        NSUUID *GetMe_RequestNumber =  [NSUUID UUID] ;
        NSString *state = @"App-side-State";
        [_connectTool appLinkDataCallBack_OpenAuthorize:notification
                                                 _state:state
                                    GetMe_RequestNumber:GetMe_RequestNumber authCallback:^(AuthorizeInfo *_token) {
            NSLog(@"Authorize 回應");
            NSLog(@"userId :%@" , _token.meInfo.data.userId);
            NSLog(@"email :%@" , _token.meInfo.data.email);
                        NSLog(@"spCoin :%ld" , (long)_token.meInfo.data.spCoin);
                        NSLog(@"rebate :%ld" , (long)_token.meInfo.data.rebate);
            
            
            [self updateMeinfo:_token.meInfo];
        }];
    }
}
```

## 發行版本切換
- 測試版 :
```objc
[ConnectToolBlack setToolVersion:testVS]; // 測試
```
- 正式版 : 
```objc
	[ConnectToolBlack setToolVersion:releaseVS]; // 正式
``` 

## 登入 / 註冊 
### 呼叫範例
```objc
- (IBAction)OpenAuthorizeURL:(id)sender {
    NSString *state  = @"App-side-State";
    [_connectTool OpenAuthorizeURL:state rootVC:self];
}
```
- state : 請填寫要驗證的內容
### 參考
- [說明](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#openauthorizeurl)
- 登入完成獲得資料 :  [登入後的資料內容](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#authorize-subsequent-events)


## 取得用戶資訊 
### 呼叫範例
```objc
-(void)GetMe_Coroutine{
    NSUUID *GetMe_RequestNumber = [NSUUID UUID]; // App-side-RequestNumber(UUID), default random
    [_connectTool GetMe_Coroutine:GetMe_RequestNumber callback:^(MeInfo * _Nonnull me) {
        NSLog(@"Authorize 回應");
        NSLog(@"userId :%@" , me.data.userId);
        NSLog(@"email :%@" , me.data.email);
        NSLog(@"nickName :%@" , me.data.nickName);
        NSLog(@"spCoin :%ld" , (long)me.data.spCoin);
        NSLog(@"rebate :%ld" , (long)me.data.rebate);
        
        [self updateMeinfo:me];
    }];
}
```
- [用戶資訊格式](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#openauthorizeurl)


## 儲值 SP
### 呼叫範例
```objc
- (IBAction)OpenRechargeURL:(id)sender {
    NSString *notifyUrl = @"";// NotifyUrl is a URL customized by the game developer
    
    NSString *state = @"Custom state";// Custom state
    
    // Step2. Set currencyCode
    NSString *currencyCode = @"2";
    [_connectTool OpenRechargeURL:currencyCode _notifyUrl:notifyUrl state:state rootVC:self];
}
```
- currencyCode : 目前 TWD 帶入 2 ([幣種對照](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#currency-code))
- notifyUrl : 遊戲開發者自訂的 URL ([Notifyurl 說明](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#notifyurl--state))
- state : 請填寫要驗證的內容
 
### 儲值 SP 測試用資料
- 測試卡號 : 4111111111111111
- 有效年月 : 11/24
- 末三碼 : 111
- OTP 密碼七碼 : 直接點選手機接收，然後輸入 OTP 密碼七碼 1234567
### 參考
[儲值說明](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#open-recharge-page)


## 消費 SP
### 呼叫範例
```objc
/// 開啟消費頁
- (IBAction)OpenConsumeSPURL:(id)sender {
    NSString *notifyUrl = @""; // NotifyUrl is a URL customized by the game
    NSString *state = [[NSUUID UUID]UUIDString];
    
    NSInteger consume_spCoin = 1;
    NSString *orderNo = [[NSUUID UUID]UUIDString];
    NSString *requestNumber = [[NSUUID UUID]UUIDString];
    
    NSString *GameName = @"GameName";
    NSString *productName = @"productName";
    
    [_connectTool OpenConsumeSPURL:consume_spCoin orderNo:orderNo GameName:GameName productName:productName _notifyUrl:notifyUrl state:state requestNumber:requestNumber rootVC:self];
}
```
- consume_spCoin : 商品定價
- orderNo : 遊戲開發者自訂的 OrderNo, String 格式
- productName : 商品名稱
- GameName : 遊戲名稱
- notifyUrl : 遊戲開發者自訂的 URL (https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#notifyurl--state)
- state : 請填寫要驗證的內容
- requestNumber : UUID

### 開啟頁面
[消費說明](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#open-consumesp-page)

### 遊戲 Server 端驗證方式
- [驗證流程參考](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#consumesp-flow)
- 請於將 NotifyUrl 設定為遊戲 Server 端網址, 消費者扣除 SP 後會發送通知到此網址
- NotifyCheck : 請回應 "ok" 或是 "true" 即可
- NotifyCheck  [參考](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#notifycheck)
