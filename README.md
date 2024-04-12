# com.17dame.connecttool_ios_oc

## 安裝
-  取得 ConnectToolKit.xcframework
-  將其資料夾直接拖拉進專案
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/images/add_to_folder.png" width="600">
-  完成安裝
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/images/Kit.png" width="350"> 

## Setting   
### 加入 ConnectToolConfig
- Add ConnectToolConfig.xcconfig to Project 
- File > New > File > Configurations > Debug & Release
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios/blob/main/images/add_config.png?raw=true" width="600">
- 命其名為 : ConnectToolConfig

- 進 Project 進行配置
![image](https://github.com/jianweiCiou/com.17dame.connecttool_ios/blob/main/images/set_config.png?raw=true)

- 填入對應資料
```txt
X_Developer_Id = 
client_secret = 
redirect_uri = 
Game_id = 
```

- Info.plist 增加數據
```XML 
    <key>X_Developer_Id</key>
    <string>$(X_Developer_Id)</string>
    <key>client_secret</key>
    <string>$(client_secret)</string>
    <key>redirect_uri</key>
    <string>$(redirect_uri)</string>
    <key>Game_id</key>
    <string>$(Game_id)</string>  
```
![image](https://github.com/jianweiCiou/com.17dame.connecttool_ios/blob/main/images/plist.png?raw=true)

## ViewController 佈局
### ConnectTool 初始
- 工具初始
- 設定測試與正式
- 註冊 17dame NotificationCenter 應用事件
```objc 
#import "ViewController.h"
#import "ConnectToolOCframework/ConnectToolBlack.h"
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
