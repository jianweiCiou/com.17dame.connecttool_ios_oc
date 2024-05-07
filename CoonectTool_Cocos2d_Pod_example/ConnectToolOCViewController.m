#import "ConnectToolOCViewController.h"
#import "ConnectToolBlack.h"

@interface ConnectToolOCViewController ()

@end

@implementation ConnectToolOCViewController

ConnectToolBlack *_connectTool;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 登入按鈕
    UIButton *login_button = [UIButton buttonWithType:UIButtonTypeSystem];
    [login_button addTarget:self
                     action:@selector(OpenAuthorizeURL:)
           forControlEvents:UIControlEventTouchUpInside];
    [login_button setTitle:@"登入 / 註冊" forState:UIControlStateNormal];
    login_button.frame = CGRectMake(16, 59, 107, 34);
    [self.view addSubview:login_button];
    
    // 用戶資料
    UIButton *me_button = [UIButton buttonWithType:UIButtonTypeSystem];
    [me_button addTarget:self
                  action:@selector(GetMe_Coroutine:)
        forControlEvents:UIControlEventTouchUpInside];
    [me_button setTitle:@"用戶資料" forState:UIControlStateNormal];
    me_button.frame = CGRectMake(16, 94, 107, 34);
    [self.view addSubview:me_button];
    
    // 切換帳號
    UIButton *SwitchAccount_button = [UIButton buttonWithType:UIButtonTypeSystem];
    [SwitchAccount_button addTarget:self
                             action:@selector(OpenSwitchAccountURL:)
                   forControlEvents:UIControlEventTouchUpInside];
    [SwitchAccount_button setTitle:@"切換帳號" forState:UIControlStateNormal];
    SwitchAccount_button.frame = CGRectMake(16, 129, 107, 34);
    [self.view addSubview:SwitchAccount_button];
    
    // 儲值 SP
    UIButton *Recharge_button = [UIButton buttonWithType:UIButtonTypeSystem];
    [Recharge_button addTarget:self
                        action:@selector(OpenRechargeURL:)
              forControlEvents:UIControlEventTouchUpInside];
    [Recharge_button setTitle:@"儲值 SP" forState:UIControlStateNormal];
    Recharge_button.frame = CGRectMake(16, 164, 107, 34);
    [self.view addSubview:Recharge_button];
    
    
    // 消費 SP
    UIButton *Consume_button = [UIButton buttonWithType:UIButtonTypeSystem];
    [Consume_button addTarget:self
                       action:@selector(OpenConsumeSPURL:)
             forControlEvents:UIControlEventTouchUpInside];
    [Consume_button setTitle:@"消費 SP" forState:UIControlStateNormal];
    Consume_button.frame = CGRectMake(16, 200, 107, 34);
    [self.view addSubview:Consume_button];
    
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
            [self ShowAlert:[[NSString alloc]initWithFormat:@"完成儲值 TradeNo :%@" , [dict valueForKey:@"TradeNo"]]];
        });
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
            [self ShowAlert:[[NSString alloc]initWithFormat:@"完成消費 orderNo :%@" , [dict valueForKey:@"orderNo"]]];
        });
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
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self ShowAlert:[[NSString alloc]initWithFormat:@"Authorize 回應 email :%@" , _token.meInfo.data.email]];
            });
        }];
    }
}


// 登入
-(void) OpenAuthorizeURL:(UIButton*)sender
{
    NSString *state  = @"App-side-State";
    [_connectTool OpenAuthorizeURL:state rootVC:self];
}

-(void)GetMe_Coroutine:(id)sender{
    NSUUID *GetMe_RequestNumber = [NSUUID UUID]; // App-side-RequestNumber(UUID), default random
    [_connectTool GetMe_Coroutine:GetMe_RequestNumber callback:^(MeInfo * _Nonnull me) {
        NSLog(@"Authorize 回應");
        NSLog(@"userId :%@" , me.data.userId);
        NSLog(@"email :%@" , me.data.email);
        NSLog(@"nickName :%@" , me.data.nickName);
        NSLog(@"spCoin :%ld" , (long)me.data.spCoin);
        NSLog(@"rebate :%ld" , (long)me.data.rebate);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ShowAlert:[[NSString alloc]initWithFormat:@"Authorize 回應 email :%@ SP coin:%ld" ,me.data.email,(long)me.data.spCoin]];
        });
    }];
}

// 切換帳號
- (void)OpenSwitchAccountURL:(id)sender {
    [_connectTool SwitchAccountURL:self];
}

/// 開啟儲值頁
- (void)OpenRechargeURL:(id)sender {
    NSString *notifyUrl = @"";// NotifyUrl is a URL customized by the game developer
    
    NSString *state = @"Custom state";// Custom state
    
    // Step2. Set currencyCode
    NSString *currencyCode = @"2";
    [_connectTool OpenRechargeURL:currencyCode _notifyUrl:notifyUrl state:state rootVC:self];
}

/// 開啟消費頁
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

- (void) ShowAlert:(NSString *)Message {
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed:139/255.0f green:139/255.0f blue:139/255.0f alpha:1.0f];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:Message];
    [AS addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0,AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

// 移除 17dame 應用事件的訂閱
- (void) dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
