<p>1、创建XCSegmentViewController的实例：<div></div>XCSegementViewController *seg = [XCSegementViewController segementViewController];</p>
<p>2、创建子控制器并设置xc_segTitle属性：<div></div>UIViewController *vc = [UIViewController new];<div></div>
        vc.xc_segTitle = @"title";</p>
<p>3、设置seg的viewControllers属性</p>
<code>
        <div></div>XCSegementViewController *seg = [XCSegementViewController segementViewController];
        <div></div> NSMutableArray *viewControllers = @[].mutableCopy;
        <div></div>NSArray *colors = @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor], [UIColor blueColor]];
        <div></div>for (NSInteger i = 1; i < 5; i++) {
        <div></div>UIViewController *vc = [UIViewController new];
        <div></div>vc.xc_segTitle = [NSString stringWithFormat:@"vc%zd", i];
        <div></div>[viewControllers addObject:vc];
        <div></div>vc.view.backgroundColor = colors[i - 1];
    <div></div>}
    <div></div>seg.viewControllers = viewControllers;</code>
