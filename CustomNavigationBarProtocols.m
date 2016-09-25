//
//  CustomNavigationBarProtocols.m
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 9/23/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "CustomNavigationBarProtocols.h"
#import <objc/runtime.h>

#pragma mark - // UINavigationItem //

@implementation UINavigationItem (CustomNavigationBar)

#pragma mark Setters and Getters

- (void)setHidesLeftBarButtonItems:(BOOL)hidesLeftBarButtonItems {
    if (hidesLeftBarButtonItems) {
        self.storedLeftBarButtonItems = self.leftBarButtonItems;
        self.leftBarButtonItems = nil;
        objc_setAssociatedObject(self, @selector(hidesLeftBarButtonItems), @(hidesLeftBarButtonItems), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        objc_setAssociatedObject(self, @selector(hidesLeftBarButtonItems), @(hidesLeftBarButtonItems), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.leftBarButtonItems = self.storedLeftBarButtonItems;
        self.storedLeftBarButtonItems = nil;
    }
}

- (BOOL)hidesLeftBarButtonItems {
    NSNumber *hidesRighBarButtonItemsValue = objc_getAssociatedObject(self, @selector(hidesLeftBarButtonItems));
    if (hidesRighBarButtonItemsValue) {
        return hidesRighBarButtonItemsValue.boolValue;
    }
    
    objc_setAssociatedObject(self, @selector(hidesLeftBarButtonItems), @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self.hidesLeftBarButtonItems;
}

- (void)setHidesTitleView:(BOOL)hidesTitleView {
    if (hidesTitleView == self.hidesTitleView) {
        return;
    }
    
    objc_setAssociatedObject(self, @selector(hidesTitleView), @(hidesTitleView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (hidesTitleView) {
        self.storedTitleView = self.titleView;
        self.titleView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    else {
        self.titleView = self.storedTitleView;
        self.storedTitleView = nil;
    }
}

- (BOOL)hidesTitleView {
    NSNumber *hidesTitleViewValue = objc_getAssociatedObject(self, @selector(hidesTitleView));
    if (hidesTitleViewValue) {
        return hidesTitleViewValue.boolValue;
    }
    
    objc_setAssociatedObject(self, @selector(hidesTitleView), @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self.hidesTitleView;
}

- (void)setHidesRightBarButtonItems:(BOOL)hidesRightBarButtonItems {
    if (hidesRightBarButtonItems) {
        self.storedRightBarButtonItems = self.rightBarButtonItems;
        self.rightBarButtonItems = nil;
        objc_setAssociatedObject(self, @selector(hidesRightBarButtonItems), @(hidesRightBarButtonItems), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        objc_setAssociatedObject(self, @selector(hidesRightBarButtonItems), @(hidesRightBarButtonItems), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.rightBarButtonItems = self.storedRightBarButtonItems;
        self.storedRightBarButtonItems = nil;
    }
}

- (BOOL)hidesRightBarButtonItems {
    NSNumber *hidesRighBarButtonItemsValue = objc_getAssociatedObject(self, @selector(hidesRightBarButtonItems));
    if (hidesRighBarButtonItemsValue) {
        return hidesRighBarButtonItemsValue.boolValue;
    }
    
    objc_setAssociatedObject(self, @selector(hidesRightBarButtonItems), @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self.hidesRightBarButtonItems;
}

- (void)setStoredTitleView:(UIView *)storedTitleView {
    objc_setAssociatedObject(self, @selector(storedTitleView), storedTitleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)storedTitleView {
    return objc_getAssociatedObject(self, @selector(storedTitleView));
}

- (void)setStoredLeftBarButtonItems:(NSArray <UIBarButtonItem *> *)storedLeftBarButtonItems {
    objc_setAssociatedObject(self, @selector(storedLeftBarButtonItems), storedLeftBarButtonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray <UIBarButtonItem *> *)storedLeftBarButtonItems {
    return objc_getAssociatedObject(self, @selector(storedLeftBarButtonItems));
}

- (void)setStoredRightBarButtonItems:(NSArray <UIBarButtonItem *> *)storedRightBarButtonItems {
    objc_setAssociatedObject(self, @selector(storedRightBarButtonItems), storedRightBarButtonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray <UIBarButtonItem *> *)storedRightBarButtonItems {
    return objc_getAssociatedObject(self, @selector(storedRightBarButtonItems));
}

@end