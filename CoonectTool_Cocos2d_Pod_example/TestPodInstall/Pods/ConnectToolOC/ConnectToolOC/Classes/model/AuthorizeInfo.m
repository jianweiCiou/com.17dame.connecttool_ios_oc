//
//  AuthorizeInfo.m
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/3.
//

#import "AuthorizeInfo.h"

@implementation AuthorizeInfo


- (instancetype)initWithClient_id:(MeInfo *)meInfo
                     connectToken:(ConnectToken *)connectToken
                            state:(NSString *)state
                     access_token:(NSString *)access_token{
    
    self = [super init];
        if (self) {
            self.meInfo = meInfo;
            self.connectToken = connectToken;
            self.state = state;
            self.access_token = access_token;
         }
        return self;
}
@end
