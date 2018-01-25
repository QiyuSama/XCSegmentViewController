//
//  QCTabViewController.m
//  XCSegementViewController
//
//  Created by xiangchao on 2017/11/30.
//  Copyright © 2017年 xiangchao. All rights reserved.
//

#import "XCSegementViewController.h"
#import <objc/runtime.h>
#import "Masonry.h"

static NSInteger const maxButtonsCountPerPage = 4;
UIColor * ColorWithRGB(CGFloat red, CGFloat green, CGFloat blue) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}

@interface XCSegementViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;
@property (weak, nonatomic) IBOutlet UIView *indicator;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, weak) UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;
@end

@implementation XCSegementViewController
+ (XCSegementViewController *)segementViewController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XCSegementViewController *seg = [mainStoryboard instantiateViewControllerWithIdentifier:@"XCSegementViewController"];
    return seg;
}

- (void)showTopView {
    if (_topView.superview) return;
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(38);
    }];
    _contentViewTop.constant = 38;
    [self.view layoutIfNeeded];
}

- (void)hideTopView {
    [_topView removeFromSuperview];
    _contentViewTop.constant = 0;
    [self.view layoutIfNeeded];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _buttons = @[].mutableCopy;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self reloadContentView];
}

- (void)makeButtuonCenter:(UIButton *)button {
    CGFloat x = button.center.x;
    
    CGFloat newOffsetX = x - _scrollView.bounds.size.width / 2;
    CGFloat maxOffsetX = _scrollView.contentSize.width - _scrollView.bounds.size.width;
    if (newOffsetX < 0) {
        newOffsetX = 0;
    }else if (newOffsetX > maxOffsetX) {
        newOffsetX = maxOffsetX;
    }
    
    [_scrollView setContentOffset:CGPointMake(newOffsetX, 0) animated:YES];
}

- (void)reloadButtons {
    if (_viewControllers.count) {
        [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_buttons removeAllObjects];
        [_viewControllers enumerateObjectsUsingBlock:^(UIViewController * vc, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:vc.xc_segTitle forState:UIControlStateNormal];
            [button setTitleColor:ColorWithRGB(153, 153, 153) forState:UIControlStateNormal];
            [button setTitleColor:ColorWithRGB(0, 122, 255) forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onTitleButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = idx;
            [_scrollViewContentView addSubview:button];
            [_buttons addObject:button];
            
            if (idx == 0) {
                button.selected = YES;
                _selectedButton = button;
                [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(1);
                    make.width.mas_equalTo(button);
                    make.leading.mas_equalTo(button);
                    make.bottom.mas_equalTo(_scrollViewContentView);
                }];
            }
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGFloat buttonWidth = width / maxButtonsCountPerPage;
            if (maxButtonsCountPerPage > _viewControllers.count) {
                buttonWidth = width / _viewControllers.count;
            }
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.and.top.mas_equalTo(_scrollViewContentView);
                make.width.mas_equalTo(buttonWidth);
                if (idx == 0) {
                    make.leading.mas_equalTo(_scrollViewContentView);
                }else {
                    make.leading.mas_equalTo(_buttons[idx - 1].mas_trailing);
                }
                if (idx == _viewControllers.count - 1) {
                    make.trailing.mas_equalTo(_scrollViewContentView).priority(220);
                }
            }];
        }];
    }
}

- (void)reloadContentView {
    [self reloadButtons];
    [_collectionView setContentOffset:CGPointZero];
    [_collectionView reloadData];
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:vc];
    }];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [vc removeFromParentViewController];
        if (vc.isViewLoaded) {
            [vc.view removeFromSuperview];
        }
    }];
    _viewControllers = [viewControllers copy];
}

- (void)onTitleButton:(UIButton *)sender {
    if (sender == _selectedButton) return;
    
    _selectedButton.selected = NO;
    sender.selected = YES;
    _selectedButton = sender;
    [_indicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(sender);
        make.leading.mas_equalTo(sender);
        make.bottom.mas_equalTo(_scrollViewContentView);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self makeButtuonCenter:sender];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [_collectionView.collectionViewLayout invalidateLayout];
    return _viewControllers.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIView *view = _viewControllers[indexPath.item].view;
    [view removeFromSuperview];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:view];
    view.frame = cell.contentView.bounds;
 
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        NSInteger idx = scrollView.contentOffset.x / scrollView.bounds.size.width;
        [self onTitleButton:_buttons[idx]];
    }
}
@end

static NSString *const titleKey = @"titleKey";
@implementation UIViewController (XCSegementViewControllerItem)
- (NSString *)xc_segTitle {
    return objc_getAssociatedObject(self, &titleKey);
}

- (void)setXc_segTitle:(NSString *)xc_segTitle {
    objc_setAssociatedObject(self, &titleKey, xc_segTitle, OBJC_ASSOCIATION_COPY);
}
@end
