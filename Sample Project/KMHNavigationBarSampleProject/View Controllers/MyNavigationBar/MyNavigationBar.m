//
//  MyNavigationBar.m
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 12/14/15.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "MyNavigationBar.h"

#pragma mark - // DEFINITIONS (Private) //

NSTimeInterval const MyNavigationBarAnimationDuration = 0.33f;

@interface MyNavigationBar ()
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UILabel *promptLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraintStatusBarHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraintShowBackButton;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraintMinimumHeight;

// GENERAL //

- (void)sizeToFitAnimated:(BOOL)animated;
- (void)reloadTitleAnimated:(BOOL)animated;

// ACTIONS //

- (IBAction)back:(id)sender;
- (IBAction)minus:(id)sender;
- (IBAction)plus:(id)sender;

// ANIMATIONS //

- (void)setBackButtonVisible:(BOOL)visible animated:(BOOL)animated withCompletion:(void(^)(BOOL finished))completionBlock;
- (void)updateConstraintsWithDuration:(NSTimeInterval)duration block:(void (^)(void))block;

@end

@implementation MyNavigationBar

#pragma mark - // SETTERS AND GETTERS //

- (void)setPrompt:(NSString *)prompt {
    [self setPrompt:prompt animated:NO];
}

- (NSString *)prompt {
    return self.promptLabel.text;
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title animated:NO];
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setMinimumHeight:(CGFloat)minimumHeight {
    [self setMinimumHeight:minimumHeight animated:NO];
}

- (CGFloat)minimumHeight {
    return self.constraintMinimumHeight.constant;
}

#pragma mark - // INITS AND LOADS //

- (id)init {
    self = [super init];
    if (self) {
        UIView *contentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        contentView.frame = self.bounds;
        [self addSubview:contentView];
    }
    return self;
}

#pragma mark - // PUBLIC METHODS //

- (void)setPrompt:(NSString *)prompt animated:(BOOL)animated {
    [self updateConstraintsWithDuration:(animated ? MyNavigationBarAnimationDuration : 0.0f) block:^{
        self.promptLabel.text = prompt;
    }];
}

- (void)setTitle:(NSString *)title animated:(BOOL)animated {
    [self updateConstraintsWithDuration:(animated ? MyNavigationBarAnimationDuration : 0.0f) block:^{
        self.titleLabel.text = title;
    }];
}

- (void)setMinimumHeight:(CGFloat)minimumHeight animated:(BOOL)animated {
    self.constraintMinimumHeight.constant = minimumHeight;
    [self sizeToFitAnimated:animated];
}

- (void)reloadAnimated:(BOOL)animated {
    [self setPrompt:self.topItem.prompt animated:animated];
    [self setTitle:self.topItem.title animated:animated];
    [self setBackButtonVisible:(self.items.count > 1) animated:animated withCompletion:nil];
}

#pragma mark - // DELEGATED METHODS (CustomNavigationBar) //

#pragma mark - // OVERWRITTEN METHODS //

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.constraintStatusBarHeight.constant = [UIApplication sharedApplication].statusBarFrame.size.height;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize navigationBarSize = [super sizeThatFits:size];
    CGSize contentViewSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return CGSizeMake(navigationBarSize.width, contentViewSize.height);
}

- (void)setItems:(NSArray <UINavigationItem *> *)items animated:(BOOL)animated {
    [super setItems:items animated:animated];
    
    [self setBackButtonVisible:(self.items.count > 1) animated:animated withCompletion:nil];
    
//    [self reloadAnimated:animated];
    
    [self sizeToFitAnimated:animated];
}

- (void)setItems:(NSArray <UINavigationItem *> *)items {
    [super setItems:items];
    
    self.topItem.hidesBackButton = YES;
    self.topItem.hidesLeftBarButtonItems = YES;
    self.topItem.hidesTitleView = YES;
    self.topItem.hidesRightBarButtonItems = YES;
}

#pragma mark - // PRIVATE METHODS (General) //

- (void)sizeToFitAnimated:(BOOL)animated {
    [self.superview setNeedsUpdateConstraints];
    [UIView animateWithDuration:(animated ? MyNavigationBarAnimationDuration : 0.0f) animations:^{
        [self sizeToFit];
        [self.superview layoutIfNeeded];
    }];
}

- (void)reloadTitleAnimated:(BOOL)animated {
    [self updateConstraintsWithDuration:(animated ? MyNavigationBarAnimationDuration : 0.0f) block:^{
        self.titleLabel.text = self.topItem.title;
    }];
}

#pragma mark - // PRIVATE METHODS (Actions) //

- (IBAction)back:(id)sender {
    if (!self.myNavigationBarDelegate) {
        return;
    }
    
    [self.myNavigationBarDelegate backButtonWasTapped:sender];
}

- (IBAction)minus:(id)sender {
    if (!self.myNavigationBarDelegate || ![self.myNavigationBarDelegate respondsToSelector:@selector(minusButtonWasTapped:)]) {
        return;
    }
    
    [self.myNavigationBarDelegate minusButtonWasTapped:sender];
}

- (IBAction)plus:(id)sender {
    if (!self.myNavigationBarDelegate || ![self.myNavigationBarDelegate respondsToSelector:@selector(plusButtonWasTapped:)]) {
        return;
    }
    
    [self.myNavigationBarDelegate plusButtonWasTapped:sender];
}

#pragma mark - // PRIVATE METHODS (Animations) //

- (void)setBackButtonVisible:(BOOL)visible animated:(BOOL)animated withCompletion:(void (^)(BOOL))completionBlock {
    self.constraintShowBackButton.active = visible;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:(animated ? MyNavigationBarAnimationDuration : 0.0f) animations:^{
        [self layoutIfNeeded];
        self.backButton.alpha = visible ? 1.0f : 0.0f;
    }];
}

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
