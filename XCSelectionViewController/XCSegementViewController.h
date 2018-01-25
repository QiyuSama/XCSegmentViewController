//
//  QCTabViewController.h
//  XCSegementViewController
//
//  Created by xiangchao on 2017/11/30.
//  Copyright © 2017年 xiangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCSegementViewController;
@protocol XCSegementViewControllerDelegate <NSObject>
- (void)tabViewController:(XCSegementViewController *)tabViewController didDisplayedController:(UIViewController *)viewController;
@end

@interface XCSegementViewController : UIViewController
/**
 设置子控制器
 */
@property (nonatomic, copy) NSArray<UIViewController *> *viewControllers;
/**
 刷新所有内容
 */
- (void)reloadContentView;
/**
 展示titleview
 */
- (void)showTopView;
/**
 隐藏titleview
 */
- (void)hideTopView;

+ (__kindof XCSegementViewController *)segementViewController;
@end

@interface UIViewController (XCSegementViewControllerItem)
@property (nonatomic, copy) NSString *xc_segTitle;
@end
