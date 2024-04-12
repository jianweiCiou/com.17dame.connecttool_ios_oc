//
//  ConnectBasic.h
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectBasic : NSObject

@property (strong, nonatomic) NSString * client_id;
@property (strong, nonatomic) NSString * X_Developer_Id;
@property (strong, nonatomic) NSString * client_secret;
@property (strong, nonatomic) NSString * Game_id;
@property (strong, nonatomic) NSString * referralCode;

- (instancetype)initWithClient_id:(NSString *)_client_id
                   X_Developer_Id:(NSString *)_X_Developer_Id
                    client_secret:(NSString *)_client_secret
                          Game_id:(NSString *)_Game_id
                     referralCode:(NSString *)_referralCode;
@end

NS_ASSUME_NONNULL_END
