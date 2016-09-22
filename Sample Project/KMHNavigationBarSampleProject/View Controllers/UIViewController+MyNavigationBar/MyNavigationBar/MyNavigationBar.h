//
//  MyNavigationBar.h
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 12/14/15.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // PROTOCOL (MyNavigationBarDelegate) //

@class MyNavigationBar;

@protocol MyNavigationBarDelegate <NSObject>
- (void)backButtonWasTapped:(MyNavigationBar *)sender;
@optional
- (void)minusButtonWasTapped:(MyNavigationBar *)sender;
- (void)plusButtonWasTapped:(MyNavigationBar *)sender;
@end

#pragma mark - // DEFINITIONS (Public) //

@interface MyNavigationBar : UINavigationBar
@property (nonatomic, weak) id <MyNavigationBarDelegate> myNavigationBarDelegate;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) CGFloat minimumHeight;
- (void)setPrompt:(NSString *)prompt animated:(BOOL)animated;
- (void)setTitle:(NSString *)title animated:(BOOL)animated;
- (void)setMinimumHeight:(CGFloat)minimumHeight animated:(BOOL)animated;
- (void)reloadAnimated:(BOOL)animated;
@end
