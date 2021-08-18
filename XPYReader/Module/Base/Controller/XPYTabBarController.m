//
//  XPYTabBarController.m
//  XPYReader
//
//  Created by zhangdu_imac on 2020/8/3.
//  Copyright © 2020 xiang. All rights reserved.
//

#import "XPYTabBarController.h"
#import "XPYNavigationController.h"
#import "XPYBookStackViewController.h"

#import "XPYSeatVC.h"

@interface XPYTabBarController ()

@end

@implementation XPYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    XPYBookStackViewController *stackController = [[XPYBookStackViewController alloc] init];
//    stackController.title = @"阅读室";
    
    XPYSeatVC *stackController = [[XPYSeatVC alloc] init];
//    XPYSeatVC.title = @"阅读室";
    
    
    XPYNavigationController *stackNavigation = [[XPYNavigationController alloc] initWithRootViewController:stackController];
    stackNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"选座" image:[[UIImage imageNamed:@"首页0"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"首页1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.viewControllers = @[stackNavigation];
    
    //config
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:91.0/255.0 green:166.0/255.0 blue:54.0/255.0 alpha:1.0];
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorWithRed:191.0/255.0 green:162.0/255.0 blue:6.0/255.0 alpha:1.0];
}

#pragma mark - Ovveride methods
- (BOOL)shouldAutorotate {
    UIViewController *controller = self.viewControllers[self.selectedIndex];
    return controller.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *controller = self.viewControllers[self.selectedIndex];
    return controller.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *controller = self.viewControllers[self.selectedIndex];
    return controller.preferredInterfaceOrientationForPresentation;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *controller = self.viewControllers[self.selectedIndex];
    return controller.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden{
    UIViewController *controller = self.viewControllers[self.selectedIndex];
    return controller.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    UIViewController *controller = self.viewControllers[self.selectedIndex];
    return controller.preferredStatusBarUpdateAnimation;
}

@end
