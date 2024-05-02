//
//  MeData.h
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeData : NSObject

@property ( strong, nonatomic) NSString * userId;
@property ( strong, nonatomic) NSString * email;
@property ( strong, nonatomic) NSString * nickName;
@property ( strong, nonatomic) NSString * avatarUrl;
@property ( nonatomic) NSInteger spCoin;
@property ( nonatomic) NSInteger rebate;

- (instancetype)initWithData:(NSString *)userId
                       email:(NSString *)email
                    nickName:(NSString *)nickName
                   avatarUrl:(NSString *)avatarUrl
                      spCoin:(NSInteger)spCoin
                      rebate:(NSInteger)rebate;
@end

NS_ASSUME_NONNULL_END
