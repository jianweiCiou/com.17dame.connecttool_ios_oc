//
//  Tool.h
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject

/// URL 編碼
/// - Parameters:
///   - string: 內容
+ (NSString*)urlEncoded:(NSString*)string;

/// 儲存最後的時間到期日
/// - Parameters:
///   - tokenData_expires_in: 取 access token
+ (void)saveExpiresTs:(NSInteger)tokenData_expires_in;


/// 取時間格式
+ (NSString *)getTimestamp;
//-(NSString *)formatDateWithString:(NSDate *)convrtedDate;
@end

NS_ASSUME_NONNULL_END
