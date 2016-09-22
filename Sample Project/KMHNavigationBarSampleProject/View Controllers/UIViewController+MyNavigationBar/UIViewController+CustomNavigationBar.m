//
//  UIViewController+CustomNavigationBar.m
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 9/14/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "UIViewController+CustomNavigationBar.h"
#import "KMHGenerics.h"
#import <objc/runtime.h>

#pragma mark - // DEFINITIONS (Private) //

@implementation UIViewController (CustomNavigationBar)

#pragma mark - // SETTERS AND GETTERS //

- (void)setEnableCustomNavigationBar:(BOOL)enableCustomNavigationBar {
    objc_setAssociatedObject(self, @selector(enableCustomNavigationBar), @(enableCustomNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)enableCustomNavigationBar {
    NSNumber *enableCustomNavigationBarValue = objc_getAssociatedObject(self, @selector(enableCustomNavigationBar));
    if (enableCustomNavigationBarValue) {
        return enableCustomNavigationBarValue.boolValue;
    }
    
    self.enableCustomNavigationBar = NO;
    return self.enableCustomNavigationBar;
}

- (void)setCustomNavigationBar:(id <CustomNavigationBar>)customNavigationBar {
    objc_setAssociatedObject(self, @selector(customNavigationBar), customNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id <CustomNavigationBar>)customNavigationBar {
    if (!self.enableCustomNavigationBar) {
        return nil;
    }
    
    id <CustomNavigationBar> customNavigationBar = objc_getAssociatedObject(self, @selector(customNavigationBar));
    if (customNavigationBar) {
        return customNavigationBar;
    }
    
    if (!self.navigationController || !self.navigationController.navigationBar || ![self.navigationController.navigationBar conformsToProtocol:@protocol(CustomNavigationBar)]) {
        return nil;
    }
    
    customNavigationBar = (id <CustomNavigationBar>)self.navigationController.navigationBar;
    self.customNavigationBar = customNavigationBar;
    return self.customNavigationBar;
}

- (void)setStoredNavigationBar:(UINavigationBar *)storedNavigationBar {
    objc_setAssociatedObject(self, @selector(storedNavigationBar), storedNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationBar *)storedNavigationBar {
    return objc_getAssociatedObject(self, @selector(storedNavigationBar));
}

- (void)setStoredBackBarButtonItem:(UIBarButtonItem *)storedBackBarButtonItem {
    objc_setAssociatedObject(self, @selector(storedBackBarButtonItem), storedBackBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)storedBackBarButtonItem {
    return objc_getAssociatedObject(self, @selector(storedBackBarButtonItem));
}

#pragma mark - // INITS AND LOADS //

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(swizzled_viewWillAppear:)];
        [self swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(swizzled_viewDidAppear:)];
        [self swizzleMethod:@selector(viewWillBePushed:) withMethod:@selector(swizzled_viewWillBePushed:)];
        [self swizzleMethod:@selector(viewWillPop:) withMethod:@selector(swizzled_viewWillPop:)];
    });
}

- (void)swizzled_viewWillAppear:(BOOL)animated {
    [self swizzled_viewWillAppear:animated];
    
    if (!self.enableCustomNavigationBar) {
        return;
    }
    
    self.navigationItem.hidesTitleView = YES; // bug fix - would prefer without this line of code
    self.navigationItem.hidesBackButton = YES; // bug fix - would prefer without this line of code
    
    self.customNavigationBar.customNavigationBarDelegate = self;
    
    if (!self.navigationController) {
        return;
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if ([self.navigationController.navigationBar isEqual:self.customNavigationBar]) {
        [self.customNavigationBar reloadAnimated:YES];
        return;
    }
    
    self.storedNavigationBar = self.navigationController.navigationBar;
    [self.navigationController setValue:self.customNavigationBar forKeyPath:NSStringFromSelector(@selector(navigationBar))];
    
    [self.customNavigationBar reloadAnimated:NO];
}

- (void)swizzled_viewDidAppear:(BOOL)animated {
    [self swizzled_viewDidAppear:animated];
    
    self.navigationItem.backBarButtonItemIsHidden = NO;
}

- (void)swizzled_viewWillBePushed:(BOOL)animated {
    [self swizzled_viewWillBePushed:animated];
    
    UIViewController *destinationViewController = self.navigationController.topViewController;
    if (destinationViewController.enableCustomNavigationBar) {
        self.navigationItem.backBarButtonItemIsHidden = YES;
    }
    else if (self.enableCustomNavigationBar) {
        [self.navigationController setValue:self.storedNavigationBar forKeyPath:NSStringFromSelector(@selector(navigationBar))];
    }
}

- (void)swizzled_viewWillPop:(BOOL)animated {
    [self swizzled_viewWillPop:animated];
    
    if (!self.enableCustomNavigationBar) {
        return;
    }
    
    UIViewController *destinationViewController = self.navigationController.topViewController;
    if (!destinationViewController.enableCustomNavigationBar) {
        [self.navigationController setValue:self.storedNavigationBar forKeyPath:NSStringFromSelector(@selector(navigationBar))];
    }
}

#pragma mark - // PUBLIC METHODS //

#pragma mark - // CATEGORY METHODS //

#pragma mark - // DELEGATED METHODS //

#pragma mark - // OVERWRITTEN METHODS //

#pragma mark - // PRIVATE METHODS //

@end
