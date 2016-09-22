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

#pragma mark - // PROTOCOLS //

#import "CustomNavigationBarProtocols.h"

#pragma mark - // DEFINITIONS (Public) //

@interface UIViewController (CustomNavigationBar)
@property (nonatomic) BOOL enableCustomNavigationBar;
@property (nonatomic, strong) id <CustomNavigationBar> customNavigationBar;
@end
