//
//  CustomNavigationBarProtocols.h
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 9/23/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // PROTOCOL (CustomNavigationBar) //

@protocol CustomNavigationBar <NSObject>
- (void)reloadAnimated:(BOOL)animated;
@optional
- (void)setTitle:(NSString *)title;
- (void)setPrompt:(NSString *)prompt;
- (void)setTitle:(NSString *)title animated:(BOOL)animated;
- (void)setPrompt:(NSString *)prompt animated:(BOOL)animated;
@end

#pragma mark - // UINavigationItem //

@interface UINavigationItem (Extras)
@property (nonatomic) BOOL hidesLeftBarButtonItems;
@property (nonatomic) BOOL hidesTitleView;
@property (nonatomic) BOOL hidesRightBarButtonItems;
@end
