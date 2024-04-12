//
//  WebViewController.h
//  ConnectToolOCframework
//
//  Created by Jianwei Ciou on 2024/4/2.
//
 
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController:UIViewController

- (void)openURLPage:(NSURL *)url;
- (void)finishWebPage;
- (void)removeWKWebsiteDataStore;

@end

NS_ASSUME_NONNULL_END
