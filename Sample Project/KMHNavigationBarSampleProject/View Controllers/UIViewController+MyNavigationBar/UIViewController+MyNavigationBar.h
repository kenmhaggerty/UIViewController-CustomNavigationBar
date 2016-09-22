//
//  UIViewController+MyNavigationBar.h
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 9/14/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"

#pragma mark - // PROTOCOLS //

#pragma mark - // DEFINITIONS (Public) //

@interface UIViewController (MyNavigationBar) <MyNavigationBarDelegate>
@property (nonatomic) BOOL enableCustomNavigationBar;
@property (nonatomic, strong, readonly) MyNavigationBar *customNavigationBar;
@end
