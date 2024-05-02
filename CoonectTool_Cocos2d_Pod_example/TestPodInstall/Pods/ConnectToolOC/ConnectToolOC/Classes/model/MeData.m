//
//  MeData.m
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import "MeData.h"

@implementation MeData

- (instancetype)initWithData:(NSString *)userId
                       email:(NSString *)email
                    nickName:(NSString *)nickName
                   avatarUrl:(NSString *)avatarUrl
                      spCoin:(NSInteger)spCoin
                      rebate:(NSInteger)rebate{
    
    self = [super init];
        if (self) {
            self.userId = userId;
            self.email = email;
            self.nickName = nickName;
            self.avatarUrl = avatarUrl;
            self.spCoin = spCoin;
            self.rebate = rebate;
         }
        return self;
    
}
@end
