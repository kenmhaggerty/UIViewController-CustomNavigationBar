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
#import <objc/runtime.h>
#import "KMHGenerics.h"

#pragma mark - // NSObject //

#pragma mark Definitions

@interface NSObject (CustomNavigationBar)
- (void)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;
@end

@implementation NSObject (CustomNavigationBar)

#pragma mark Public Methods

// copied w/ modifications via Mattt Thompson's tutorial at http://nshipster.com/method-swizzling/
- (void)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    // ...
    // Method originalMethod = class_getClassMethod(class, originalSelector);
    // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end

#pragma mark - // UINavigationBar //

@implementation UINavigationBar (CustomNavigationBar)

#pragma mark Inits and Loads

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(setItems:) withMethod:@selector(swizzled_setItems:)];
    });
}

#pragma mark Swizzled Methods

- (void)swizzled_setItems:(NSArray <UINavigationItem *> *)items {
    if (self.topItem) {
        [self removeObserversFromNavigationItem:self.topItem];
    }
    
    [self swizzled_setItems:items];
    
    if (self.topItem) {
        [self addObserversToNavigationItem:self.topItem];
    }
}

#pragma mark Private Methods (Observers)

- (void)addObserversToNavigationItem:(UINavigationItem *)navigationItem {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationItemTitleDidChange:) name:UINavigationItemTitleDidChangeNotification object:navigationItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationItemPromptDidChange:) name:UINavigationItemPromptDidChangeNotification object:navigationItem];
}

- (void)removeObserversFromNavigationItem:(UINavigationItem *)navigationItem {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UINavigationItemTitleDidChangeNotification object:navigationItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UINavigationItemPromptDidChangeNotification object:navigationItem];
}

#pragma mark Private Methods (Responders)

- (void)navigationItemTitleDidChange:(NSNotification *)notification {
    NSString *title = notification.userInfo[UINavigationItemNotificationObjectKey];
    
    UINavigationBar <CustomNavigationBar> *customNavigationBar = (UINavigationBar <CustomNavigationBar> *)self;
    if ([customNavigationBar respondsToSelector:@selector(setTitle:animated:)]) {
        [customNavigationBar setTitle:title animated:YES];
    }
    else if ([customNavigationBar respondsToSelector:@selector(setTitle:)]) {
        customNavigationBar.title = title;
    }
}

- (void)navigationItemPromptDidChange:(NSNotification *)notification {
    NSString *prompt = notification.userInfo[UINavigationItemNotificationObjectKey];
    
    UINavigationBar <CustomNavigationBar> *customNavigationBar = (UINavigationBar <CustomNavigationBar> *)self;
    if ([customNavigationBar respondsToSelector:@selector(setPrompt:animated:)]) {
        [customNavigationBar setPrompt:prompt animated:YES];
    }
    else if ([customNavigationBar respondsToSelector:@selector(setPrompt:)]) {
        customNavigationBar.prompt = prompt;
    }
}

@end

#pragma mark - // UINavigationItem //

#pragma mark Notifications

NSString * const UINavigationItemNotificationObjectKey = @"kUINavigationItemNotificationObjectKey";

NSString * const UINavigationItemTitleDidChangeNotification = @"kUINavigationItemTitleDidChangeNotification";
NSString * const UINavigationItemPromptDidChangeNotification = @"kUINavigationItemPromptDidChangeNotification";

#pragma mark Definitions

@interface UINavigationItem (CustomNavigationBar)
@property (nonatomic) BOOL backBarButtonItemIsHidden;
@end

@implementation UINavigationItem (CustomNavigationBar)

#pragma mark Setters and Getters

- (void)setBackBarButtonItemIsHidden:(BOOL)backBarButtonItemIsHidden {
    if (backBarButtonItemIsHidden == self.backBarButtonItemIsHidden) {
        return;
    }
    
    objc_setAssociatedObject(self, @selector(backBarButtonItemIsHidden), @(backBarButtonItemIsHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (backBarButtonItemIsHidden) {
        self.storedBackBarButtonItem = self.backBarButtonItem;
        self.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    else {
        self.backBarButtonItem = self.storedBackBarButtonItem;
        self.storedBackBarButtonItem = nil;
    }
}

- (BOOL)backBarButtonItemIsHidden {
    NSNumber *backBarButtonItemIsHiddenValue = objc_getAssociatedObject(self, @selector(backBarButtonItemIsHidden));
    if (backBarButtonItemIsHiddenValue) {
        return backBarButtonItemIsHiddenValue.boolValue;
    }
    
    objc_setAssociatedObject(self, @selector(backBarButtonItemIsHidden), @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self.backBarButtonItemIsHidden;
}

- (void)setStoredBackBarButtonItem:(UIBarButtonItem *)storedBackBarButtonItem {
    objc_setAssociatedObject(self, @selector(storedBackBarButtonItem), storedBackBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)storedBackBarButtonItem {
    return objc_getAssociatedObject(self, @selector(storedBackBarButtonItem));
}

#pragma mark Inits and Loads

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(setTitle:) withMethod:@selector(swizzled_setTitle:)];
        [self swizzleMethod:@selector(setPrompt:) withMethod:@selector(swizzled_setPrompt:)];
    });
}

#pragma mark Swizzled Methods

- (void)swizzled_setTitle:(NSString *)title {
    if ((!title && !self.title) || ([title isEqualToString:self.title])) {
        return;
    }
    
    [self swizzled_setTitle:title];
    
    NSDictionary *userInfo = title ? @{UINavigationItemNotificationObjectKey : title} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:UINavigationItemTitleDidChangeNotification object:self userInfo:userInfo];
}

- (void)swizzled_setPrompt:(NSString *)prompt {
    if ((!prompt && !self.prompt) || ([prompt isEqualToString:self.prompt])) {
        return;
    }
    
    [self swizzled_setPrompt:prompt];
    
    NSDictionary *userInfo = prompt ? @{UINavigationItemNotificationObjectKey : prompt} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:UINavigationItemPromptDidChangeNotification object:self userInfo:userInfo];
}

@end

#pragma mark - // UIViewController //

@implementation UIViewController (CustomNavigationBar)

#pragma mark Setters and Getters

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

- (void)setCustomNavigationBar:(UINavigationBar <CustomNavigationBar> *)customNavigationBar {
    objc_setAssociatedObject(self, @selector(customNavigationBar), customNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationBar <CustomNavigationBar> *)customNavigationBar {
    UINavigationBar <CustomNavigationBar> *customNavigationBar = objc_getAssociatedObject(self, @selector(customNavigationBar));
    if (customNavigationBar) {
        return customNavigationBar;
    }
    
    if (!self.navigationController || !self.navigationController.navigationBar || ![self.navigationController.navigationBar conformsToProtocol:@protocol(CustomNavigationBar)]) {
        return nil;
    }
    
    customNavigationBar = (UINavigationBar <CustomNavigationBar> *)self.navigationController.navigationBar;
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

#pragma mark Inits and Loads

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(swizzled_viewWillAppear:)];
        [self swizzleMethod:@selector(viewWillPush:) withMethod:@selector(swizzled_viewWillPush:)];
        [self swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(swizzled_viewDidAppear:)];
        [self swizzleMethod:@selector(viewWillDisappear:) withMethod:@selector(swizzled_viewWillDisappear:)];
        [self swizzleMethod:@selector(viewWillBePushed:) withMethod:@selector(swizzled_viewWillBePushed:)];
        [self swizzleMethod:@selector(viewWillPop:) withMethod:@selector(swizzled_viewWillPop:)];
    });
}

- (void)swizzled_viewWillAppear:(BOOL)animated {
    [self swizzled_viewWillAppear:animated];
    
    if (self.isMovingToParentViewController) { // && ![self.navigationController.viewControllers.firstObject isEqual:self]
        [self viewWillPush:animated];
    }
    
    if (!self.enableCustomNavigationBar) {
        return;
    }
    
    if (!self.navigationController) {
        return;
    }
    
    [self.navigationController setValue:nil forKeyPath:NSStringFromSelector(@selector(navigationBar))];
    [self.navigationController setValue:self.customNavigationBar forKeyPath:NSStringFromSelector(@selector(navigationBar))];
}

- (void)swizzled_viewWillPush:(BOOL)animated {
    [self swizzled_viewWillPush:animated];
    
    if (!self.enableCustomNavigationBar) {
        return;
    }
    
    if (!self.navigationController) {
        return;
    }
    
    if (![self.navigationController.navigationBar isMemberOfClass:[UINavigationBar class]]) {
        self.storedNavigationBar = self.navigationController.navigationBar;
    }
}

- (void)swizzled_viewDidAppear:(BOOL)animated {
    [self swizzled_viewDidAppear:animated];
    
    self.navigationItem.backBarButtonItemIsHidden = NO;
    
    [self.customNavigationBar reloadAnimated:animated];
}

- (void)swizzled_viewWillDisappear:(BOOL)animated {
    [self swizzled_viewWillDisappear:animated];
    
    if (!self.navigationController) {
        return;
    }
    
    if (self.isMovingFromParentViewController) {
        [self viewWillPop:animated];
    }
    else if (!self.isMovingFromParentViewController) {
        [self viewWillBePushed:animated];
    }
}

- (void)swizzled_viewWillBePushed:(BOOL)animated {
    [self swizzled_viewWillBePushed:animated];
    
    UIViewController *destinationViewController = self.navigationController.topViewController;
    if (destinationViewController.enableCustomNavigationBar) {
        self.navigationItem.backBarButtonItemIsHidden = YES;
    }
    else if (self.enableCustomNavigationBar) {
        [self.navigationController setValue:[[UINavigationBar alloc] init] forKeyPath:NSStringFromSelector(@selector(navigationBar))];
    }
}

- (void)swizzled_viewWillPop:(BOOL)animated {
    [self swizzled_viewWillPop:animated];
    
    if (!self.enableCustomNavigationBar) {
        return;
    }
    
    if ([self.customNavigationBar isEqual:self.storedNavigationBar]) {
        return;
    }
    
    UINavigationBar *navigationBar = self.storedNavigationBar;
    if (!self.storedNavigationBar) {
        navigationBar = [[UINavigationBar alloc] init];
    }
    [self.navigationController setValue:nil forKeyPath:NSStringFromSelector(@selector(navigationBar))];
    [self.navigationController setValue:navigationBar forKeyPath:NSStringFromSelector(@selector(navigationBar))];
}

#pragma mark Public Methods

- (void)viewWillPush:(BOOL)animated {
    // empty
}

- (void)viewWillBePushed:(BOOL)animated {
    // empty
}

- (void)viewWillPop:(BOOL)animated {
    // empty
}

@end
