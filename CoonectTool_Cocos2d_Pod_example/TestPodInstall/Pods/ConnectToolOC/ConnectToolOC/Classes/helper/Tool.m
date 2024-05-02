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
    //    NSString *unreserved = @"!*'\"();:@&=+$,/?%#[]% ";
    //    NSMutableCharacterSet *allowed = [NSMutableCharacterSet alphanumericCharacterSet];
    //
    //    [allowed addCharactersInString:unreserved];
    //
    //    return  [string
    //             stringByAddingPercentEncodingWithAllowedCharacters:
    //                 allowed];
    
    //    NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet URLQueryAllowedCharacterSet];
    //    [charactersToKeep addCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "];
    //
    //    NSCharacterSet *allowedCharacters = [charactersToKeep invertedSet];
    //
    //    NSString *encodedString = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    //
    //    return encodedString;
    
    NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet alphanumericCharacterSet];
    [charactersToKeep addCharactersInString:@"!*'\"();@&=+$,?%#[]% "];
    
    NSCharacterSet *charactersToRemove = [charactersToKeep invertedSet];
    
    /* NSString *trimmedReplacement = [[string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@"" ];*/
    
    NSString *trimmedReplacement = [string stringByAddingPercentEncodingWithAllowedCharacters:charactersToRemove];
    
    return trimmedReplacement;
}


+ (void)saveExpiresTs:(NSInteger)tokenData_expires_in{
    double expires_in = [[NSNumber numberWithInteger:tokenData_expires_in] floatValue];
    expires_in = expires_in * 0.9 ;
    
//    NSDate *date = [NSDate date];
    NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
    double currentTs = ti  ;
    
    //
    double expiresTs = currentTs + expires_in;
    
    // 測試到期
    //    double expiresTs = currentTs + 1;
    
//    NSLog(@"tokenData_expires_in %ld",(long)tokenData_expires_in);
//    NSLog(@"到期時間 %f, 現在時間 %f",expiresTs,currentTs);
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f", expiresTs] forKey:@"expiresTs"];
}


+ (NSString *)getTimestamp{
    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat: @"%@Z", dateString];
}


@end
