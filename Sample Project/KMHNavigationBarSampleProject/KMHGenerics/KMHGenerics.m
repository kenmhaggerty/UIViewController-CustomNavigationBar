//
//  KMHGenerics.m
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 9/22/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "KMHGenerics.h"
#import <objc/runtime.h>

#pragma mark - // NSObject //

@interface NSObject (KMHGenerics)
- (void)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;
@end

@implementation NSObject (KMHGenerics)

#pragma mark Private Methods

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

#pragma mark - // UINavigationItem //

#pragma mark Notifications

NSString * const UINavigationItemNotificationObjectKey = @"kUINavigationItemNotificationObjectKey";

NSString * const UINavigationItemTitleDidChangeNotification = @"kUINavigationItemTitleDidChangeNotification";
NSString * const UINavigationItemPromptDidChangeNotification = @"kUINavigationItemPromptDidChangeNotification";

@implementation UINavigationItem (KMHGenerics)

#pragma mark Inits and Loads

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(setPrompt:) withMethod:@selector(swizzled_setPrompt:)];
        [self swizzleMethod:@selector(setTitle:) withMethod:@selector(swizzled_setTitle:)];
    });
}

#pragma mark Swizzled Methods

- (void)swizzled_setPrompt:(NSString *)prompt {
    if ((!prompt && !self.prompt) || ([prompt isEqualToString:self.prompt])) {
        return;
    }
    
    [self swizzled_setPrompt:prompt];
    
    NSDictionary *userInfo = prompt ? @{UINavigationItemNotificationObjectKey : prompt} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:UINavigationItemPromptDidChangeNotification object:self userInfo:userInfo];
}

- (void)swizzled_setTitle:(NSString *)title {
    if ((!title && !self.title) || ([title isEqualToString:self.title])) {
        return;
    }
    
    [self swizzled_setTitle:title];
    
    NSDictionary *userInfo = title ? @{UINavigationItemNotificationObjectKey : title} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:UINavigationItemTitleDidChangeNotification object:self userInfo:userInfo];
}

@end

#pragma mark - // UIView //

@implementation UIView (KMHGenerics)

#pragma mark Public Methods

- (void)updateConstraintsWithDuration:(NSTimeInterval)duration block:(void (^)(void))block {
    if (block) {
        block();
    }
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}

@end
