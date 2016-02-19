//
//  ViewController.h
//  抽屉效果
//
//  Created by 余亮 on 15/8/3.
//  Copyright (c) 2015年 余亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
//如果需要向外面暴露，则需要加上readonly
@property(nonatomic,weak,readonly)UIView * mainV ;
@property(nonatomic,weak,readonly)UIView * leftV ;
@property(nonatomic,weak,readonly)UIView * rightV ;

@end

