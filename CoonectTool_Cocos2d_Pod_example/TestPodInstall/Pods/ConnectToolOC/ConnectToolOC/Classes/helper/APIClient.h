//
//  APIClient.h
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import <Foundation/Foundation.h>
#import "ConnectToolBlack.h"
#import "ConnectBasic.h"
#import "ConnectToken.h"
#import "MeInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIClient : NSObject

+ (NSString*)host;
+ (NSString*)host_test;
+ (NSString*)host_release;

+ (NSString*)game_api_host;
+ (NSString*)game_api_host_test;
+ (NSString*)game_api_host_release;

+ (void)setHost:(NSString*)newhost;
+ (void)setGame_api_host:(NSString*)newgame_api_host;

+ (void)getRefreshTokenData:(ConnectToolBlack *)_connectToolBlack
connectBasic:(ConnectBasic *)connectBasic
              refresh_token:(NSString *)refresh_token
               redirect_uri:(NSString *)redirect_uri
           connectTokenCall:(void (^)(ConnectToken *_token))connectTokenCall;

+ (void) getConnectToken:(ConnectToolBlack *)_connectToolBlack
connectBasic:(ConnectBasic*)connectBasic
_code:(NSString*)_code
redirect_uri:(NSString*)redirect_uri
        connectTokenCall:(void (^)(ConnectToken *_token))connectTokenCall;


+ (void) getMe:(ConnectToolBlack *)_connectToolBlack
X_Developer_Id:(NSString *)X_Developer_Id
 RequestNumber:(NSString *)RequestNumber
        GameId:(NSString *)GameId
  ReferralCode:(NSString *)ReferralCode
callbackMeInfo:(void (^)(MeInfo *_token))callbackMeInfo;

+ (NSString*) signature:(NSString*)string RSAstr:(NSString*)RSAstr; 

@end

NS_ASSUME_NONNULL_END
