//
//  ConnectToken.h
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectToken : NSObject

@property (strong, nonatomic) NSString * access_token;
@property (strong, nonatomic) NSString * token_type;
@property ( nonatomic) NSInteger expires_in;
@property (strong, nonatomic) NSString * refresh_token;
 

- (instancetype)initWithAccess_token:(NSString *)_access_token
                          token_type:(NSString *)_token_type
                          expires_in:(NSInteger)_expires_in
                       refresh_token:(NSString *)_refresh_token;
@end

NS_ASSUME_NONNULL_END
