<p>1、创建XCSegmentViewController的实例：XCSegementViewController *seg = [XCSegementViewController segementViewController];</p>
<p>2、创建子控制器并设置xc_segTitle属性：UIViewController *vc = [UIViewController new];
        vc.xc_segTitle = @"title";</p>
<p>3、设置seg的viewControllers属性</p>
<code>XCSegementViewController *seg = [XCSegementViewController segementViewController];</r>
    NSMutableArray *viewControllers = @[].mutableCopy;
    NSArray *colors = @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor], [UIColor blueColor]];
    for (NSInteger i = 1; i < 5; i++) {
        UIViewController *vc = [UIViewController new];
        vc.xc_segTitle = [NSString stringWithFormat:@"vc%zd", i];
        [viewControllers addObject:vc];
        vc.view.backgroundColor = colors[i - 1];
    }
    seg.viewControllers = viewControllers;</code>
