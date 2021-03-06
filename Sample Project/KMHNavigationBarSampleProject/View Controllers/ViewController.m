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
#import "UIViewController+CustomNavigationBar.h"
#import "MyNavigationBar.h"

#pragma mark - // DEFINITIONS (Private) //

CGFloat const MyNavigationBarIncrementValue = 20.0f;

@interface ViewController () <MyNavigationBarDelegate, UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet UITextField *promptTextField;
@property (nonatomic, strong) IBOutlet UITextField *titleTextField;
@property (nonatomic, strong) MyNavigationBar *myNavigationBar;
@end

@implementation ViewController

#pragma mark - // SETTERS AND GETTERS //

- (void)setMyNavigationBar:(MyNavigationBar *)myNavigationBar {
    self.customNavigationBar = myNavigationBar;
}

- (MyNavigationBar *)myNavigationBar {
    if (!self.customNavigationBar || ![self.customNavigationBar isKindOfClass:[MyNavigationBar class]]) {
        return nil;
    }
    
    return (MyNavigationBar *)self.customNavigationBar;
}

#pragma mark - // INITS AND LOADS //

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.myNavigationBar) {
        return;
    }
    
    self.myNavigationBar = [[MyNavigationBar alloc] init];
    self.myNavigationBar.myNavigationBarDelegate = self;
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

#pragma mark - // DELEGATED METHODS (MyNavigationBarDelegate) //

- (void)backButtonWasTapped:(MyNavigationBar *)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)minusButtonWasTapped:(MyNavigationBar *)sender {
    [self.myNavigationBar setMinimumHeight:fmaxf(self.myNavigationBar.minimumHeight-MyNavigationBarIncrementValue, 0.0f) animated:YES];
}

- (void)plusButtonWasTapped:(MyNavigationBar *)sender {
    [self.myNavigationBar setMinimumHeight:fmaxf(self.myNavigationBar.minimumHeight+MyNavigationBarIncrementValue, self.myNavigationBar.frame.size.height+MyNavigationBarIncrementValue) animated:YES];
}

#pragma mark - // DELEGATED METHODS //

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.titleTextField]) {
        self.navigationItem.title = textField.text;
    }
    else if ([textField isEqual:self.promptTextField]) {
        self.navigationItem.prompt = textField.text;
    }
}

#pragma mark - // OVERWRITTEN METHODS //

- (BOOL)enableCustomNavigationBar {
    return YES;
}

#pragma mark - // PRIVATE METHODS //

@end
