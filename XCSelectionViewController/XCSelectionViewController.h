//
//  XCSelectionViewController.h
//  XCSelectionViewController
//
//  Created by xiangchao on 16/5/4.
//  Copyright © 2016年 STV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCSelectionViewController : UIViewController
+ (instancetype)selectionViewControllerWithChildViewControllers:(NSArray<UIViewController *> *)childViewControllers titles:(NSArray<NSString *> *)titles;
@end
