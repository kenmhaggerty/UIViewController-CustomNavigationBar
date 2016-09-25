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
