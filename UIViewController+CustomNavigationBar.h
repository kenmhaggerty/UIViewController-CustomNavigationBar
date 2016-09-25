//
//  UIViewController+CustomNavigationBar.h
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 9/14/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // UINavigationItem //

#pragma mark Notifications

extern NSString * const UINavigationItemNotificationObjectKey;

extern NSString * const UINavigationItemTitleDidChangeNotification;
extern NSString * const UINavigationItemPromptDidChangeNotification;

#pragma mark - // UIViewController //

#pragma mark Protocols

#import "CustomNavigationBarProtocols.h"

#pragma mark Methods

@interface UIViewController (CustomNavigationBar)
@property (nonatomic) BOOL enableCustomNavigationBar;
@property (nonatomic, strong) UINavigationBar <CustomNavigationBar> *customNavigationBar;
- (void)viewWillPush:(BOOL)animated;
- (void)viewWillBePushed:(BOOL)animated;
- (void)viewWillPop:(BOOL)animated;
- (void)viewDidPop:(BOOL)animated;
@end
