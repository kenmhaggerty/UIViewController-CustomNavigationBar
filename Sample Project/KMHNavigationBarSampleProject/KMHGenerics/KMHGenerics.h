//
//  KMHGenerics.h
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 9/22/16.
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

#pragma mark - // UIView //

#pragma mark Methods

@interface UIView (KMHGenerics)
- (void)updateConstraintsWithDuration:(NSTimeInterval)duration block:(void (^)(void))block;
@end
