//
//  MeInfo.h
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import <Foundation/Foundation.h>
#import "MeData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeInfo : NSObject
@property (strong,nonatomic) NSString * message;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * requestNumber;
@property (strong,nonatomic) MeData * data;

- (instancetype)initWithMeData:(NSString *)status
                 requestNumber:(NSString *)requestNumber
                          data:(MeData *)data;
- (instancetype)initWithNSDictionary:(NSDictionary *)responseDictionary;

@end

NS_ASSUME_NONNULL_END
