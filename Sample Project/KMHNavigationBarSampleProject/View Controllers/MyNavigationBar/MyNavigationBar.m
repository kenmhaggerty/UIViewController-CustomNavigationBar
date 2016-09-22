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
#import "KMHGenerics.h"

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

// OBSERVERS //

- (void)addObserversToNavigationItem:(UINavigationItem *)navigationItem;
- (void)removeObserversFromNavigationItem:(UINavigationItem *)navigationItem;

// RESPONDERS //

- (void)navigationItemPromptDidChange:(NSNotification *)notification;
- (void)navigationItemTitleDidChange:(NSNotification *)notification;

// ANIMATIONS //

- (void)setBackButtonVisible:(BOOL)visible animated:(BOOL)animated withCompletion:(void(^)(BOOL finished))completionBlock;

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

#pragma mark - // DELEGATED METHODS //

#pragma mark - // OVERWRITTEN METHODS //

- (void)layoutSubviews {
    [super layoutSubviews];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIView *contentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        contentView.frame = self.bounds;
        [self addSubview:contentView];
    });
    
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
    
    [self sizeToFitAnimated:animated];
}

- (void)setItems:(NSArray <UINavigationItem *> *)items {
    if ((!items && !self.items) || ([items isEqualToArray:self.items])) {
        return;
    }
    
    if (self.topItem) {
        [self removeObserversFromNavigationItem:self.topItem];
    }
    
    [super setItems:items];
    
    if (self.topItem) {
        [self addObserversToNavigationItem:self.topItem];
    }
    
    [self reloadTitleAnimated:NO];
}

- (void)pushNavigationItem:(UINavigationItem *)item animated:(BOOL)animated {
    [super pushNavigationItem:item animated:animated];
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
    if (!self.customNavigationBarDelegate) {
        return;
    }
    
    [self.customNavigationBarDelegate backButtonWasTapped:sender];
}

- (IBAction)minus:(id)sender {
    if (!self.customNavigationBarDelegate || ![self.customNavigationBarDelegate respondsToSelector:@selector(minusButtonWasTapped:)]) {
        return;
    }
    
    [self.customNavigationBarDelegate minusButtonWasTapped:sender];
}

- (IBAction)plus:(id)sender {
    if (!self.customNavigationBarDelegate || ![self.customNavigationBarDelegate respondsToSelector:@selector(plusButtonWasTapped:)]) {
        return;
    }
    
    [self.customNavigationBarDelegate plusButtonWasTapped:sender];
}

#pragma mark - // PRIVATE METHODS (Observers) //

- (void)addObserversToNavigationItem:(UINavigationItem *)navigationItem {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationItemPromptDidChange:) name:UINavigationItemPromptDidChangeNotification object:navigationItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationItemTitleDidChange:) name:UINavigationItemTitleDidChangeNotification object:navigationItem];
}

- (void)removeObserversFromNavigationItem:(UINavigationItem *)navigationItem {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UINavigationItemPromptDidChangeNotification object:navigationItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UINavigationItemTitleDidChangeNotification object:navigationItem];
}

#pragma mark - // PRIVATE METHODS (Responders) //

- (void)navigationItemPromptDidChange:(NSNotification *)notification {
    NSString *prompt = notification.userInfo[UINavigationItemNotificationObjectKey];
    
    [self setPrompt:prompt animated:YES];
}

- (void)navigationItemTitleDidChange:(NSNotification *)notification {
    NSString *title = notification.userInfo[UINavigationItemNotificationObjectKey];
    
    [self setTitle:title animated:YES];
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

@end
