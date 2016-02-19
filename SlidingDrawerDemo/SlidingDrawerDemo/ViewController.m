//
//  ViewController.m
//  抽屉效果
//
//  Created by 余亮 on 15/8/3.
//  Copyright (c) 2015年 余亮. All rights reserved.
//

//#define YLKeyPath @"frame"   //宏具有拷贝的功能，会把右边的拷贝到左边

#define YLKeyPath(objc,keypath) ((void)objc.keypath ,@"frame")  //自动提示宏,逗号表达式

#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AddSubViews];
    
    //添加拖拽手势  -- 因为要拿到mainView，故设置为成员属性
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(PanAction:)];
    [_mainV addGestureRecognizer:pan];
    
    //添加点按手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self.view addGestureRecognizer:tap];    //注意；这里的_mainV指的是红色的view，而self.view是指当前现实的界面上的view
    
    //时刻监听某个对象的属性的改变----使用KVO,记得移除观察者模式
    //Observer   -- 观察者
    //KeyPath  --  监听的属性
    //NSKeyValueObservingOptionNew   -- 表示监听 新值的改变
    [_mainV addObserver:self forKeyPath:YLKeyPath(_mainV, frame) options:NSKeyValueObservingOptionNew context:nil];
    
}
- (void) dealloc
{
    [_mainV removeObserver:self forKeyPath:YLKeyPath(_mainV, frame)];
}
//只要监听的属性一改变就会调用
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //    NSLog(@"%@",NSStringFromCGRect(_mainV.frame));
    //根据main的x值的大小来判断用户向左还是向右滑动，若向左，则表明leftView显示，若向右，则表示rightView显示
    if (_mainV.frame.origin.x < 0) {   //向左滑动
        _rightV.hidden = NO;             //这里if里面都是设置的_rightV.hidden，这里很高明
    }else if(_mainV.frame.origin.x > 0)
        _rightV.hidden = YES ;
}



- (void) PanAction:(UIPanGestureRecognizer *)pan
{
    //获取手势偏移量
    CGPoint transP =   [pan translationInView:_mainV];
    //获取x轴的偏移量----相对于上一次的
    CGFloat offX = transP.x ;
    //获取当前的x,y,w,h
    //先获取当前main的frame
    //    CGRect frame = _mainV.frame ;
    //    frame.origin.x+=offX ;
    
    //修改main.frame，计算的x,y,w,h
    _mainV.frame =  [self frameWithOffsetX:offX];
    
    //复位
    [pan setTranslation:CGPointZero inView:_mainV];
    CGFloat targetR = 300 ;
    CGFloat targetL = -230 ;
    
    //根据手指的抬起状态，判断如何定位，手指抬起则定位
    if (pan.state == UIGestureRecognizerStateEnded) {
        //x > 屏幕的一半,定位到右边某个位置
        CGFloat target = 0;
        if (_mainV.frame.origin.x > screenW*0.5) {
            target = targetR ;
        }else if(CGRectGetMaxX(_mainV.frame) < screenW*0.5 ) {      //最大的x < 屏幕的一半，定位到左边某个位置
            target = targetL ;
        }
        //获取x轴的偏移量
        [UIView animateWithDuration:0.3 animations:^{
            
            CGFloat offsetX = target - _mainV.frame.origin.x ;
            _mainV.frame = [self    frameWithOffsetX:offsetX];
        }];
    }
}

- (void) tapAction:(UITapGestureRecognizer *)tap
{
    
    if ( 0 != _mainV.frame.origin.x ) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _mainV.frame = self.view.bounds;     //其实不需要判断
        }];
    }
}

#define YLMaxY 100     //定义为宏

//给定一个x轴的偏移量计算出最新的main的位置
- (CGRect)frameWithOffsetX:(CGFloat)offX
{
    //获取main的frame
    CGRect frame = _mainV.frame ;
    CGFloat x =   frame.origin.x+offX ;
    frame.origin.x = x ;
    
    //获取最新的y
    CGFloat y = x/screenW *YLMaxY ;
    //这里需要判断：当用户手指往左滑动时候，比例系数不变，将y的值取反
    if (_mainV.frame.origin.x < 0) {
        y = -y ;
    }
    //获取最新的h
    CGFloat h = screenH - 2*y;
    //获取缩放比例
    CGFloat scale = h/screenH;
    //获取最新的w
    CGFloat w = screenW*scale;
    return CGRectMake(x, y, w, h) ;
    
    
}


- (void) AddSubViews
{
    UIView * leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    leftView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:leftView];
    //给成员属性赋值
    _leftV = leftView ;
    
    
    UIView * rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    rightView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:rightView];
    _rightV = rightView ;
    
    
    UIView * mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    mainView.backgroundColor = [UIColor redColor];
    [self.view addSubview:mainView];
    _mainV = mainView ;
}


@end
