# com.17dame.connecttool_ios_oc_Pod 
此範例使用 [Cocoapods : ConnectToolOC](https://cocoapods.org/pods/ConnectToolOC) 與 Cocos2d 來完成登入, 註冊, 切換帳號, 取出用戶資料, 儲值與消費等功能

 
## 安裝 Pod
### Install
-  Terminal 移動到 iOS 專案資料夾下,例如：/proj.ios_mac/專案.xcodeproj
-  執行指令 pod init, 產生出 Podfile
- 在 Podfile 專案 target 中加入 :  pod 'ConnectToolOC', '~> 0.1'

```txt
# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target '專案-desktop' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for 專案-desktop
end

target '專案-mobile' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for 專案-mobile

  pod 'ConnectToolOC', '~> 0.1'
end
```
- 填妥後回到 Terminal ,並執行 pod repo update
- 更新完後執行 pod install

### Pod 調整
- 把 pod 對應的.xcconfig添加到 iOS 裡 
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_Pod_example/images/InfoConfig.png" width="500">


### 執行
- 專案資料夾 proj.ios_mac 會新增 "專案.xcworkspace", 用.xcworkspace 來開啟專案
- 開啟 Product -> Clean Build Folder, 清除資料 
- 完成安裝


## Setting   
### 加入 ConnectToolConfig
- Add ConnectToolConfig.xcconfig to Project 
- File > New > File > Configurations > Debug & Release
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios/blob/main/images/add_config.png?raw=true" width="500">

- 命其名為 : ConnectToolConfig

- 進 Project 進行配置
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_Pod_example/images/projectConfig.jpg" width="500">

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
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_Pod_example/images/info.jpg" width="500">


## Sample ViewController 佈局
### 取得 sample code 
- 檔案位置:
[ConnectToolOCViewController.h](https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_Pod_example/ConnectToolOCViewController.h)
[ConnectToolOCViewController.m](https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_Pod_example/ConnectToolOCViewController.m)

- 請將 ConnectToolOCViewController 加入到專案中的 iOS 資料夾
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_Pod_example/images/ios_folder.jpg" width="300">

### AppController 安排測試資料
- AppController.h 加入 ConnectToolOCViewController 與 相關參數
```objc 
#import "ConnectToolOCViewController.h"

// 加入跳轉參數
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController * navController;
@property (nonatomic, retain) ConnectToolOCViewController * connectToolVC;
```
- AppController.m 
- 建置 window, 可以此範例來使用 ConnectToolOCViewController 進行測試
```objc  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    cocos2d::Application *app = cocos2d::Application::getInstance();
    
    // Initialize the GLView attributes
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();
    
    // Override point for customization after application launch.
    
    // 建置 window
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    // Use RootViewController to manage CCEAGLView
    _connectToolVC = [[ConnectToolOCViewController alloc]init];
    _connectToolVC.wantsFullScreenLayout = YES;
    
    _navController = [[UINavigationController alloc] init];
    [_navController pushViewController:_connectToolVC animated:NO];
    _navController.navigationBarHidden = YES;
    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0){
        // warning: addSubView doesn't work on iOS6
        [window addSubview:_navController.view];
    }
    else{
        // use this method on ios6
        [window setRootViewController:_navController];
    }
    [window makeKeyAndVisible];
    [ [UIApplication sharedApplication] setStatusBarHidden: YES];
    
    return YES;
}
```

## ConnectToolOCViewController 佈局 
### ConnectTool 初始
- 工具初始
- 設定測試與正式
- 註冊 17dame NotificationCenter 應用事件
```objc 
#import "ConnectToolOCViewController.h"
#import "ConnectToolBlack.h"
``` 
```objc 
@implementation ConnectToolOCViewController 
ConnectToolBlack *_connectTool; 
- (void)viewDidLoad {
    [super viewDidLoad];

    ...

    // 工具初始
    NSString *RSAstr = @"";
    
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
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
-(void) OpenAuthorizeURL:(UIButton*)sender
{
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
-(void)GetMe_Coroutine:(id)sender{
    NSUUID *GetMe_RequestNumber = [NSUUID UUID]; // App-side-RequestNumber(UUID), default random
    [_connectTool GetMe_Coroutine:GetMe_RequestNumber callback:^(MeInfo * _Nonnull me) {
        NSLog(@"Authorize 回應");
        NSLog(@"userId :%@" , me.data.userId);
        NSLog(@"email :%@" , me.data.email);
        NSLog(@"nickName :%@" , me.data.nickName);
        NSLog(@"spCoin :%ld" , (long)me.data.spCoin);
        NSLog(@"rebate :%ld" , (long)me.data.rebate); 
    }];
}
```
- [用戶資訊格式](https://github.com/jianweiCiou/com.17dame.connecttool_android/tree/main?tab=readme-ov-file#openauthorizeurl)


## 儲值 SP
### 呼叫範例
```objc
- (void)OpenRechargeURL:(id)sender {
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
- (void)OpenConsumeSPURL:(id)sender {
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

 
