//
//  Tool.m
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//

#import "Tool.h"

@implementation Tool

/// URL 編碼
/// - Parameters:
///   - string: 內容
+ (NSString*)urlEncoded:(NSString*)string{
    
    NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet alphanumericCharacterSet];
    [charactersToKeep addCharactersInString:@"!*'\"();@&=+$,?%#[]% "];
    
    NSCharacterSet *charactersToRemove = [charactersToKeep invertedSet];
    
    NSString *trimmedReplacement = [string stringByAddingPercentEncodingWithAllowedCharacters:charactersToRemove];
    
    return trimmedReplacement;
}


+ (void)saveExpiresTs:(NSInteger)tokenData_expires_in{
    double expires_in = [[NSNumber numberWithInteger:tokenData_expires_in] floatValue];
    expires_in = expires_in * 0.9 ;
     
    NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
    double currentTs = ti  ;
     
    double expiresTs = currentTs + expires_in;
     
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f", expiresTs] forKey:@"expiresTs"];
}


+ (NSString *)getTimestamp{
    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat: @"%@Z", dateString];
}


@end
