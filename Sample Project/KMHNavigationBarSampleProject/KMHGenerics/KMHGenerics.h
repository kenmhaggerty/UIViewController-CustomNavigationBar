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

#pragma mark - // NSObject //

#pragma mark Public Methods

@interface NSObject (KMHGenerics)
- (void)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;
@end

#pragma mark - // UINavigationItem //

#pragma mark Notifications

extern NSString * const UINavigationItemNotificationObjectKey;

extern NSString * const UINavigationItemTitleDidChangeNotification;
extern NSString * const UINavigationItemPromptDidChangeNotification;

@interface UINavigationItem (KMHGenerics)
@property (nonatomic) BOOL hidesTitleView;
@property (nonatomic) BOOL backBarButtonItemIsHidden;
@end

#pragma mark - // UIView //

#pragma mark Public Methods

@interface UIView (KMHGenerics)
- (void)updateConstraintsWithDuration:(NSTimeInterval)duration block:(void (^)(void))block;
@end

#pragma mark - // UIViewController //

#pragma mark Public Methods

@interface UIViewController ()
- (void)viewWillBePushed:(BOOL)animated;
- (void)viewWillPop:(BOOL)animated;
- (void)viewDidPop:(BOOL)animated;
@end
