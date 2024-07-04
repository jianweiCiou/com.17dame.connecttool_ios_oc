//
//  AuthorizeInfo.h
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/3.
//

#import <Foundation/Foundation.h>
#import "MeInfo.h"
#import "ConnectToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorizeInfo : NSObject
@property ( strong,  nonatomic) MeInfo * meInfo;
@property ( strong, nonatomic) ConnectToken * connectToken;
@property ( strong, nonatomic) NSString * state;
@property ( strong, nonatomic) NSString * access_token;


- (instancetype)initWithClient_id:(MeInfo *)meInfo
                     connectToken:(ConnectToken *)connectToken
                            state:(NSString *)state
                     access_token:(NSString *)access_token;


@end

NS_ASSUME_NONNULL_END
