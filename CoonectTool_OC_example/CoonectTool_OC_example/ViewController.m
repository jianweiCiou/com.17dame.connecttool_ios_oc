//
//  ViewController.m
//  CoonectTool_OC_example
//
//  Created by Jianwei Ciou on 2024/4/12.
//

#import "ViewController.h"
#import "ConnectToolOCframework/ConnectToolBlack.h"

@interface ViewController ()

@end

@implementation ViewController

ConnectToolBlack *_connectTool;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

/// 17dame 應用事件回應
- (void) r17dame_ReceiverCallback:(NSNotification *) notification
{
    NSDictionary *dict = notification.userInfo;
    NSString *backType = [dict valueForKey:@"accountBackType"];
    
    //    NSLog(@"17dame 應用事件回應 :%@" ,backType);
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
    
    // Complete consumption of SP Coin
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

// 更新用戶資料
- (void)updateMeinfo:(MeInfo *)me {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.userID setText:[NSString stringWithFormat:@"UserID : %@",me.data.userId]];
        [self.email setText:[NSString stringWithFormat:@"Email : %@",me.data.email]];
        [self.spCoin setText:[NSString stringWithFormat:@"SpCoin : %ld",(long)me.data.spCoin]];
        [self.rebate setText:[NSString stringWithFormat:@"Rebate : %ld",(long)me.data.rebate]];
    });
}

// 登入 / 註冊
- (IBAction)OpenAuthorizeURL:(id)sender {
    NSString *state  = @"App-side-State";
    [_connectTool OpenAuthorizeURL:state rootVC:self];
}

// 取用戶登入資料
- (IBAction)GetMe_Coroutine:(id)sender {
    [self GetMe_Coroutine];
}

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


// 切換帳號
- (IBAction)OpenSwitchAccountURL:(id)sender {
    [_connectTool SwitchAccountURL:self];
}

/// 開啟儲值頁
/// [here](https://github.com/jianweiCiou/com.17dame.connecttool_android/blob/main/README.md#open-recharge-page))
- (IBAction)OpenRechargeURL:(id)sender {
    NSString *notifyUrl = @"";// NotifyUrl is a URL customized by the game developer
    
    NSString *state = @"Custom state";// Custom state
    
    // Step2. Set currencyCode
    NSString *currencyCode = @"2";
    [_connectTool OpenRechargeURL:currencyCode _notifyUrl:notifyUrl state:state rootVC:self];
}


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

// 移除 17dame 應用事件的訂閱
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"r17dame_ReceiverCallback" object:nil];
}
@end
