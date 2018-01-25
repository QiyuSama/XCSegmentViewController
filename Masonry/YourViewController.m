//
//  YourViewController.m
//  XCSegmentViewController
//
//  Created by xiangchao on 2017/12/28.
//  Copyright © 2017年 STV. All rights reserved.
//

#import "YourViewController.h"
#import "Masonry.h"

@interface YourViewController ()

@end

@implementation YourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    XCSegementViewController *seg = [XCSegementViewController segementViewController];
    NSMutableArray *viewControllers = @[].mutableCopy;
    NSArray *colors = @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor], [UIColor blueColor]];
    for (NSInteger i = 1; i < 5; i++) {
        UIViewController *vc = [UIViewController new];
        vc.xc_segTitle = [NSString stringWithFormat:@"vc%zd", i];
        [viewControllers addObject:vc];
        vc.view.backgroundColor = colors[i - 1];
    }
    seg.viewControllers = viewControllers;
    seg.view.frame = self.view.bounds;
    seg.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:seg.view];
}

@end
