//
//  YLSlideViewController.m
//  抽屉效果
//
//  Created by 余亮 on 15/8/4.
//  Copyright (c) 2015年 余亮. All rights reserved.
//

#import "YLSlideViewController.h"

@interface YLSlideViewController ()

@end

@implementation YLSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //搞一个tableview 让它随着我们的mainView尺寸大小一同变化，需要用到容器池,占位思想
    //创建tableview控制器
    UITableViewController * tableVc = [[UITableViewController alloc] init];
    tableVc.view.frame = self.mainV.frame ;
    [self.mainV addSubview:tableVc.view];
    
    //设计原理：如果A控制器的view成为B控制器的view的子控件，那么A控制器必须成为B控制器的子控制器,否则会被销毁
    [self addChildViewController:tableVc];
}




@end
