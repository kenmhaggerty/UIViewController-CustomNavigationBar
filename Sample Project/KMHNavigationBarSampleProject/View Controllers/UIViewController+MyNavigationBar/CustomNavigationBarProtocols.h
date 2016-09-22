//
//  CustomNavigationBarProtocols.h
//  KMHNavigationBarSampleProject
//
//  Created by Ken M. Haggerty on 9/22/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <Foundation/Foundation.h>

#pragma mark - // DEFINITIONS (Public) //

#pragma mark - // PROTOCOL (CustomNavigationBar) //

@protocol CustomNavigationBar <NSObject>
@property (nonatomic, weak) id customNavigationBarDelegate;
- (void)reloadAnimated:(BOOL)animated;
@end
