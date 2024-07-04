//
//  MeInfo.m
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import "MeInfo.h"

@implementation MeInfo

- (instancetype)initWithMeData:(NSString *)status
                 requestNumber:(NSString *)requestNumber
                          data:(MeData *)data{
    
    
    self = [super init];
    if (self) {
        self.status = status;
        self.requestNumber = requestNumber;
        self.data = data;
    }
    return self;
}
- (instancetype)initWithNSDictionary:(NSDictionary *)responseDictionary{
    
    self = [super init];
    if (self) {
        NSDictionary *data = [responseDictionary objectForKey:@"data"];
        NSString *userId = [data objectForKey:@"userId"];
        NSString *avatarUrl = [data objectForKey:@"avatarUrl"];
        NSString *email = [data objectForKey:@"email"];
        NSString *nickName = [data objectForKey:@"nickName"];
        NSInteger rebate = [[data  objectForKey:@"rebate"]intValue];
        NSInteger spCoin = [[data objectForKey:@"spCoin"]intValue];
        
        MeData *mData = [[MeData alloc]initWithData:userId email:email nickName:nickName avatarUrl:avatarUrl spCoin:spCoin rebate:rebate];
        
        NSString *requestNumber = [responseDictionary objectForKey:@"requestNumber"];
        NSString *status = [responseDictionary objectForKey:@"status"];
        
        self = [[MeInfo alloc]initWithMeData:status requestNumber:requestNumber data:mData];
    }
    return self;
}
@end
