//
//  XCScrollView.m
//  XCSelectionViewController
//
//  Created by xiangchao on 16/5/4.
//  Copyright © 2016年 STV. All rights reserved.
//

#import "XCScrollView.h"

@implementation XCScrollView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    if (_didClickBlock) {
        _didClickBlock(location);
    }
}
@end
