//
//  ViewController.m
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 9/22/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "ViewController.h"
#import "UIViewController+MyNavigationBar.h"

#pragma mark - // DEFINITIONS (Private) //

CGFloat const MyNavigationBarIncrementValue = 20.0f;

@interface ViewController ()
@end

@implementation ViewController

#pragma mark - // SETTERS AND GETTERS //

#pragma mark - // INITS AND LOADS //

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.enableCustomNavigationBar = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - // PUBLIC METHODS //

#pragma mark - // CATEGORY METHODS //

#pragma mark - // DELEGATED METHODS (CustomNavigationBarDelegate) //

- (void)backButtonWasTapped:(MyNavigationBar *)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)minusButtonWasTapped:(MyNavigationBar *)sender {
    [self.customNavigationBar setMinimumHeight:fmaxf(self.customNavigationBar.minimumHeight-MyNavigationBarIncrementValue, 0.0f) animated:YES];
}

- (void)plusButtonWasTapped:(MyNavigationBar *)sender {
    [self.customNavigationBar setMinimumHeight:fmaxf(self.customNavigationBar.minimumHeight+MyNavigationBarIncrementValue, self.customNavigationBar.frame.size.height+MyNavigationBarIncrementValue) animated:YES];
}

#pragma mark - // OVERWRITTEN METHODS //

#pragma mark - // PRIVATE METHODS //

@end
