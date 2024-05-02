//
//  ConnectBasic.m
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import "ConnectBasic.h"

@implementation ConnectBasic

- (instancetype)initWithClient_id:(NSString *)_client_id
                   X_Developer_Id:(NSString *)_X_Developer_Id
                    client_secret:(NSString *)_client_secret
                          Game_id:(NSString *)_Game_id
                     referralCode:(NSString *)_referralCode{
    
    self = [super init];
        if (self) {
            self.client_id = _client_id;
            self.X_Developer_Id = _X_Developer_Id;
            self.client_secret = _client_secret;
            self.Game_id = _Game_id;
            self.referralCode = _referralCode;
        }
        return self;
}
@end
