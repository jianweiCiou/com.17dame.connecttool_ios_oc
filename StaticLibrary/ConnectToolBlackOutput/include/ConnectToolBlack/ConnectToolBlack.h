//
//  ConnectToolBlack.h
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/1.
//

#ifndef ConnectToolBlack_h
#define ConnectToolBlack_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumConstants.h"
#import "AuthorizeInfo.h"
#import "ConnectBasic.h"

/// Tool 版本, 分測試與發行
//typedef enum {
//    testVS,
//    releaseVS
//} TOOL_VERSION;
//
///// 平台版本
//typedef enum {
//    nativeVS,
//    cocos2dVS
//} PLATFORM_VERSION;
 
NS_ASSUME_NONNULL_BEGIN
 

@interface ConnectToolBlack : NSObject

@property (strong, nonatomic) ConnectBasic *connectBasic;
    
- (instancetype)initWithToolInfo:(NSString *)RSAstr
                       client_id:(NSString *)client_id
                  X_Developer_Id:(NSString *)X_Developer_Id
                   client_secret:(NSString *)client_secret
                         Game_id:(NSString *)Game_id
                 platformVersion:(PLATFORM_VERSION)platformVersion;

- (void) appLinkDataCallBack_OpenAuthorize:(NSNotification*)notification
                                   _state:(NSString*)_state
                      GetMe_RequestNumber:(NSUUID*)GetMe_RequestNumber
                              authCallback:(void (^)(AuthorizeInfo *_token))authCallback;
/** GET */
+ (TOOL_VERSION )toolVersion;
+ (PLATFORM_VERSION )platformVersion;
+ (NSString*)Secret;
+ (NSString*)ClientID;
+ (NSString*)Game_id;
+ (NSString*)_me;
+ (NSString*)access_token;
+ (NSString*)RSAstr;
+ (NSString*)requestNumber;
+ (NSString*)notifyUrl;
+ (NSString*)redirect_uri;
+ (NSString*)referralCode;

/** SET */
+ (void)setRedirect_uri:(NSString*)newredirect_uri;
+ (void)setRSAstr:(NSString*)newRSAstr;
+ (void)setClient_id:(NSString*)newclient_id;
+ (void)setX_Developer_Id:(NSString*)newX_Developer_Id;
+ (void)setClient_secret:(NSString*)newclient_secret;
+ (void)setGame_id:(NSString*)newGame_id;

/// 設定平台 native or cocos2d
/// - Parameters:
///   - _platformVersion: 原生或遊戲
+ (void)setPlatformVersion:(PLATFORM_VERSION)platformVersion;
+ (void)setToolVersion:(TOOL_VERSION)toolVersion; 

/// 開啟登入與註冊頁面
/// - Parameters:
///   - _state:  state
///   - rootVC:  state
- (void) OpenAuthorizeURL:(NSString *) _state
                   rootVC:(UIViewController *)rootVC;
- (void) GetMe_Coroutine:(NSUUID*)_GetMeRequestNumber
                callback:(void (^)(MeInfo *me))callback;
- (void) SwitchAccountURL:(UIViewController *)rootVC;
- (void) OpenRechargeURL:(NSString*)currencyCode _notifyUrl:(NSString*)_notifyUrl state:(NSString*)state rootVC:(UIViewController*)rootVC;
- (void) OpenConsumeSPURL:(NSInteger)consume_spCoin
                  orderNo:(NSString*)orderNo
                 GameName:(NSString*)GameName
              productName:(NSString*)productName
               _notifyUrl:(NSString*)_notifyUrl
                    state:(NSString*)state
            requestNumber:(NSString*)requestNumber
                   rootVC:(UIViewController*)rootVC;
@end
NS_ASSUME_NONNULL_END


#endif /* ConnectToolBlack_h */
