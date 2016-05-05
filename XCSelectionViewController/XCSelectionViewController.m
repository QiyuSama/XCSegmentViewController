//
//  XCSelectionViewController.m
//  XCSelectionViewController
//
//  Created by xiangchao on 16/5/4.
//  Copyright © 2016年 STV. All rights reserved.
//

#import "XCSelectionViewController.h"
#import "UIView+Extension.h"
#import "XCScrollView.h"
#define kTitleFont ([UIFont systemFontOfSize:17])
#define kMargin 20

@interface XCSelectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (copy, nonatomic) NSArray *titles;
@property (copy, nonatomic) NSArray<UILabel *> *titleLabels;
@property (strong, nonatomic) XCScrollView *scrollView;
@property (assign, nonatomic) CGFloat contentSizeW;
@property (assign, nonatomic) CGFloat margin;
@property (strong, nonatomic) UIView *underLine;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) UICollectionView *contentView;
@property (assign, nonatomic) BOOL isSwip;
@end

@implementation XCSelectionViewController

#pragma mark - lifecircle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTitleLabels];
    [self createScrollView];
    [self creatUnderLine];
    [self createContenView];
    _selectedIndex = -1;
    [self selectedIndex:0];
    
  
    
}

#pragma mark - createUI
- (NSArray *)createTitleLabels
{
    NSMutableArray *titleLabels = [NSMutableArray arrayWithCapacity:_titles.count];
    for (NSInteger i = 0; i < _titles.count; i++) {
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.text = _titles[i];
        titleLable.font = kTitleFont;
        titleLable.numberOfLines = 1;
        CGSize size = [_titles[i] sizeWithAttributes:@{NSFontAttributeName:kTitleFont}];
        _contentSizeW += size.width + kMargin;
        CGFloat x;
        if (i == 0) {
            x = kMargin;
        }else
        {
            UILabel *lable = titleLabels[i - 1];
            x = CGRectGetMaxX(lable.frame) + kMargin;
        }
        
        titleLable.frame = CGRectMake(x, (44 - size.height) / 2, size.width, size.height);
        [titleLabels addObject:titleLable];
    }
    _contentSizeW += kMargin;
    
    self.titleLabels = [NSArray arrayWithArray:titleLabels];
    _margin = kMargin;
    if (_contentSizeW < kScreenWidth) {
        [self reCountLabelX];
    }
    return _titleLabels;
}

//必须在createTitleLabels之后调用
- (UIScrollView *)createScrollView
{
    CGFloat y;
    if (self.navigationController) {
        y = 64;
    }else
    {
        y = 0;
    }
    _scrollView = [[XCScrollView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, 44)];
    _scrollView.contentSize = CGSizeMake(_contentSizeW, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    
    [self.view addSubview:_scrollView];
    for (UILabel *label in _titleLabels) {
        [_scrollView addSubview:label];
    }
    _scrollView.backgroundColor = [UIColor redColor];
    __weak typeof(self) weakSelf = self;
    _scrollView.didClickBlock = ^(CGPoint location){
    
        NSInteger index = [weakSelf selectedItemWithLoaction:location];
        
        if (index != NSNotFound) {
            
            [weakSelf selectedIndex:index];
        }
        
    };
    return _scrollView;
}

- (UICollectionView *)createContenView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _contentView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), _scrollView.width, self.view.height - CGRectGetMaxY(_scrollView.frame))collectionViewLayout:flowLayout];
    [self.view addSubview:_contentView];
    flowLayout.itemSize = _contentView.frame.size;
    flowLayout.minimumLineSpacing = 0;
    [_contentView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    _contentView.dataSource = self;
    _contentView.delegate = self;
    _contentView.pagingEnabled = YES;
    _contentView.bounces = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    return _contentView;
}

- (UIView *)creatUnderLine
{
    _underLine = [[UIView alloc] init];
    _underLine.height = 2;
    _underLine.width = _titleLabels[_selectedIndex].width;
    _underLine.x = _titleLabels[_selectedIndex].x;
    _underLine.y = _scrollView.height - _underLine.height;
    _underLine.backgroundColor = [UIColor yellowColor];
    [_scrollView addSubview:_underLine];
    return _underLine;
}

- (void)moveUnderLineWithSelectedIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _underLine.x = _titleLabels[_selectedIndex].x;
        _underLine.width = _titleLabels[_selectedIndex].width;
    }];
}

- (NSInteger)selectedItemWithLoaction:(CGPoint)location
{
    NSInteger index = NSNotFound;
    for(NSInteger i = 0; i < _titleLabels.count; i++){
        if (CGRectGetMaxX(_titleLabels[i].frame) >= location.x) {
            return i;
        }
    }

    return index;
}

- (void)reCountLabelX
{
    CGFloat allWidth;
    for (UILabel *label in _titleLabels) {
        allWidth += label.width;
    }
    _margin = (kScreenWidth - allWidth) / (_titleLabels.count + 1);
    for (NSInteger i = 0; i < _titleLabels.count; i++) {
        if (i == 0) {
            _titleLabels[i].x = _margin;
        }else
        {
            _titleLabels[i].x = CGRectGetMaxX(_titleLabels[i - 1].frame) + _margin;
        }
    }
}

- (void)gotoCenterWithIndex:(NSInteger)index
{
    UILabel *label = _titleLabels[index];
    CGFloat centerX = label.center.x;
    CGFloat centerOffsetX = centerX - _scrollView.width / 2;
    if (centerOffsetX < 0 ) {
        centerOffsetX = 0;
    }else if (centerOffsetX > _scrollView.contentSize.width - _scrollView.width){
        centerOffsetX = _scrollView.contentSize.width - _scrollView.width;
    }
    [_scrollView setContentOffset:CGPointMake(centerOffsetX, 0) animated:YES];
}

- (void)selectedIndex:(NSInteger)index
{
    if(_selectedIndex == index) return;

    
    _selectedIndex = index;
    
    if (!_isSwip) {
        [_contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else
    {
        _isSwip = NO;
    }
    
    [self moveUnderLineWithSelectedIndex:self.selectedIndex];

    self.title = self.titles[index];

    [self gotoCenterWithIndex:index];
}

#pragma mark - 父类的方法
- (void)addChildViewController:(UIViewController *)childController
{
    [super addChildViewController:childController];
    
}

#pragma mark - 对外接口
+ (instancetype)selectionViewControllerWithChildViewControllers:(NSArray<UIViewController *> *)childViewControllers titles:(NSArray<NSString *> *)titles
{
    NSAssert(titles.count == childViewControllers.count, @"子控制器个数与title个数不匹配");
    XCSelectionViewController *selectionViewController = [self new];
    selectionViewController.titles = titles;
    for (UIViewController *vc in childViewControllers) {
        [selectionViewController addChildViewController:vc];
    }
    return selectionViewController;
}

#pragma mark - action

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:self.childViewControllers[indexPath.row].view];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isSwip = YES;
    [self selectedIndex:indexPath.row];
}
@end
