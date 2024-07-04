//
//  APIClient.m
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import "APIClient.h"
#import "Tool.h"

@implementation APIClient

static NSString *host=@"";
static NSString *host_test=@"gamar18portal.azurewebsites.net";
static NSString *host_release=@"www.17dame.com";

static NSString *game_api_host=@"";
static NSString *game_api_host_test=@"r18gameapi.azurewebsites.net";
static NSString *game_api_host_release=@"gameapi.17dame.com";

/** GET   */
+ (NSString*)host{
    return host;
}
+ (NSString*)host_test{
    return host_test;
}
+ (NSString*)host_release{
    return host_release;
}
+ (NSString*)game_api_host{
    return game_api_host;
}
+ (NSString*)game_api_host_test{
    return game_api_host_test;
}
+ (NSString*)game_api_host_release{
    return game_api_host_release;
}
+ (void)setHost:(NSString*)newhost{
    host = newhost;
}
+ (void)setGame_api_host:(NSString*)newgame_api_host{
    game_api_host = newgame_api_host;
}


+ (void) getConnectToken:(ConnectToolBlack *)_connectToolBlack
            connectBasic:(ConnectBasic*)connectBasic
                   _code:(NSString*)_code
            redirect_uri:(NSString*)redirect_uri
        connectTokenCall:(void (^)(ConnectToken *_token))connectTokenCall{
    
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://%@/connect/token",APIClient.host]];
    
    NSString *redirect_uri_Encoded = [Tool urlEncoded:redirect_uri];
    NSString *client_secret_Encoded = [Tool urlEncoded:connectBasic.client_secret];
    
    NSData * data = [[NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", _code,connectBasic.client_id,client_secret_Encoded,redirect_uri_Encoded] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responseData, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)responseData;
        
//        NSLog(@"The responseData is - %@",responseData);
        
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//            NSLog(@"The response is - %@",responseDictionary);
            
            NSString *access_token = [responseDictionary objectForKey:@"access_token"];
            NSString *refresh_token = [responseDictionary objectForKey:@"refresh_token"];
            NSString *token_type = [responseDictionary objectForKey:@"token_type"];
            NSInteger expires_in = [[responseDictionary objectForKey:@"expires_in"] integerValue];
            
            // 儲存時間 / 儲存tokeen
            [Tool saveExpiresTs:expires_in];
            [[NSUserDefaults standardUserDefaults] setValue:access_token forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] setValue:refresh_token forKey:@"refresh_token"];
            
            ConnectToken *token = [[ConnectToken alloc]initWithAccess_token:access_token token_type:token_type expires_in:expires_in refresh_token:refresh_token];
            
            connectTokenCall(token);
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    
    [task resume];
}

+ (void) getRefreshTokenData:(ConnectToolBlack *)_connectToolBlack
                connectBasic:(ConnectBasic*)connectBasic
               refresh_token:(NSString*)refresh_token
                redirect_uri:(NSString*)redirect_uri
            connectTokenCall:(void (^)(ConnectToken *_token))connectTokenCall{
    
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://%@/connect/token",APIClient.host]];
    
    NSString *redirect_uri_Encoded = [Tool urlEncoded:redirect_uri];
    NSString *client_secret_Encoded = [Tool urlEncoded:connectBasic.client_secret];
    
    //  NSLog(@"url - %@",url.absoluteString);
    //
    //  NSLog(@"query - %@",[NSString stringWithFormat:@"refresh_token=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", refresh_token,connectBasic.client_id,client_secret_Encoded,redirect_uri_Encoded]);
    
    NSData * data = [[NSString stringWithFormat:@"refresh_token=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=refresh_token", refresh_token,connectBasic.client_id,client_secret_Encoded,redirect_uri_Encoded] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responseData, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)responseData;
        
//              NSLog(@"The responseData is - %@",responseData);
        
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//            NSLog(@"The response is - %@",responseDictionary);
            
            NSString *access_token = [responseDictionary objectForKey:@"access_token"];
            NSString *refresh_token = [responseDictionary objectForKey:@"refresh_token"];
            NSString *token_type = [responseDictionary objectForKey:@"token_type"];
            NSInteger expires_in = [[responseDictionary objectForKey:@"expires_in"] integerValue];
            
            // 儲存時間 / 儲存tokeen
            [Tool saveExpiresTs:expires_in];
            [[NSUserDefaults standardUserDefaults] setValue:access_token forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] setValue:refresh_token forKey:@"refresh_token"];
            
            
            ConnectToken *token = [[ConnectToken alloc]initWithAccess_token:access_token token_type:token_type expires_in:expires_in refresh_token:refresh_token];
            
            connectTokenCall(token);
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    
    [task resume];
}


+ (void) getMe:(ConnectToolBlack *)_connectToolBlack
X_Developer_Id:(NSString *)X_Developer_Id
 RequestNumber:(NSString *)RequestNumber
        GameId:(NSString *)GameId
  ReferralCode:(NSString *)ReferralCode
callbackMeInfo:(void (^)(MeInfo *_token))callbackMeInfo{
    
    NSString * timestamp = [Tool getTimestamp];
    
    NSString * signdata = [NSString stringWithFormat: @"?RequestNumber=%@&Timestamp=%@&GameId=%@&ReferralCode=%@",
                           RequestNumber,
                           timestamp,
                           [Tool urlEncoded:ConnectToolBlack.Game_id],
                           [Tool urlEncoded:ConnectToolBlack.referralCode]];
    
    NSString * access_token = [[NSUserDefaults standardUserDefaults]valueForKey:@"access_token"];
    
    NSString * authorization = [NSString stringWithFormat: @"Bearer %@",access_token];
    
    NSString *X_Signature = [APIClient signature:signdata RSAstr:ConnectToolBlack.RSAstr];
    
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://%@/api/Me%@",APIClient.game_api_host, signdata]];
    
    
    //    NSLog(@"The signdata is - %@",signdata);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"Content-Type: application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    [request setValue:_connectToolBlack.connectBasic.X_Developer_Id forHTTPHeaderField:@"X-Developer-Id"];
    [request setValue:X_Signature forHTTPHeaderField:@"X-Signature"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responseData, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)responseData;
//                NSLog(@"The response is - %@",responseData);
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionaryAll = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            NSDictionary *responseDictionary = [responseDictionaryAll valueForKey:@"data"];
            
            NSData *meInfoData = [NSKeyedArchiver
                                  archivedDataWithRootObject:responseDictionary requiringSecureCoding:YES error:&parseError];
            
            if (error) {
                NSLog(@"Got an error: %@", [error localizedDescription]);
            }
            
            
            [[NSUserDefaults standardUserDefaults] setValue:meInfoData forKey:@"me"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            MeInfo *me = [[MeInfo alloc]initWithNSDictionary:responseDictionaryAll];
            
            callbackMeInfo(me);
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    
    [task resume];
}


+ (NSString*) signature:(NSString*)string RSAstr:(NSString*)RSAstr{
    
    NSString *derString = [[[RSAstr stringByReplacingOccurrencesOfString: @"-----BEGIN RSA PRIVATE KEY-----" withString:@""]stringByReplacingOccurrencesOfString: @"-----END RSA PRIVATE KEY-----" withString:@""]stringByReplacingOccurrencesOfString: @"\n" withString:@""];
    
    NSData *derData = [[NSData alloc]initWithBase64EncodedString:derString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]initWithCapacity:1];
    [attributes setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [attributes setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [attributes setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)kSecAttrKeyClass];
    [attributes setObject:@(2048) forKey:(__bridge id)kSecAttrKeySizeInBits];
    
    CFErrorRef err;
    SecKeyRef privateKey = SecKeyCreateWithData((__bridge CFDataRef)derData, (__bridge CFDictionaryRef)attributes, &err);
    
    SecKeyAlgorithm algorithm = kSecKeyAlgorithmRSASignatureMessagePKCS1v15SHA256;
    BOOL canSign = SecKeyIsAlgorithmSupported(privateKey, kSecKeyOperationTypeSign, algorithm);
    
    NSData *plainTextData = [string dataUsingEncoding:NSUTF8StringEncoding];
    CFDataRef cfData = (__bridge CFDataRef)plainTextData;
    
    NSData* signature = nil;
    if (canSign) {
        CFErrorRef error = NULL;
        signature = (NSData*)CFBridgingRelease(SecKeyCreateSignature(privateKey,
                                                                     algorithm,
                                                                     cfData,
                                                                     &error));
        if (!signature) {
            //            NSError *err = CFBridgingRelease(error);  // ARC takes ownership
            //            // Handle the error. . .
            //            NSLog(@"failed to sign.\n");
        }
    }
    
    NSString *sigString = [signature base64EncodedStringWithOptions:0];
    
    return  sigString;;
}
@end
