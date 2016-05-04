//
//  XCScrollView.h
//  XCSelectionViewController
//
//  Created by xiangchao on 16/5/4.
//  Copyright © 2016年 STV. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidClickBlock)(CGPoint point);
@interface XCScrollView : UIScrollView
@property (copy, nonatomic)DidClickBlock didClickBlock;
@end
