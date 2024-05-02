//
//  ConnectToken.m
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import "ConnectToken.h"

@implementation ConnectToken


- (instancetype)initWithAccess_token:(NSString *)_access_token
                          token_type:(NSString *)_token_type
                          expires_in:(NSInteger)_expires_in
                       refresh_token:(NSString *)_refresh_token{
    
    self = [super init];
        if (self) {
            self.access_token = _access_token;
            self.token_type = _token_type;
            self.expires_in = _expires_in;
            self.refresh_token = _refresh_token;
        }
        return self;
}
@end
