//
//  ADNewHomePageViewController.m
//  anbang_ios
//
//  Created by 王奥东 on 17/4/1.
//  Copyright © 2017年 ch. All rights reserved.
//

#import "ADNewHomePageViewController.h"
#import "ADGooeySlideView.h"



@interface ADNewHomePageViewController ()<UIGestureRecognizerDelegate> {
    ADGooeySlideView *_menu;//左侧视图
    CGFloat x;
}
@property(nonatomic, strong)UIPanGestureRecognizer * pan;

@property(nonatomic, weak)UIViewController *vc;//主Window的控制器
@end

@implementation ADNewHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menu = [[ADGooeySlideView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [self.view addSubview:_menu];
//    [window addSubview:_menu];
    
    
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    menuView.backgroundColor = [UIColor redColor];
    [window addSubview:menuView];
    
    //滑动手势
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:self.pan];
    
    [self.pan setCancelsTouchesInView:YES];
    self.pan.delegate = self;
    
    self.view.backgroundColor = [UIColor orangeColor];
    x=0;
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    _vc = vc;
    [menuView addSubview:vc.view];
//    vc.view
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor blueColor];

}


#pragma mark - 滑动手势

//滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    
    CGPoint point = [rec translationInView:self.view];
    
    //缩放比例
    CGFloat scale = 1-(point.x/1500);
    
    if (point.x > 0) {
        //往右滑动，滑动一部分，出现一部分
        if (_menu.frame.origin.x < 0) {
            CGRect frame = _menu.frame;
            frame.origin.x += point.x/10;
            _menu.frame = frame;
            
            if (_menu.frame.origin.x > 0) {
                CGRect frame = _menu.frame;
                frame.origin.x = 0;
                _menu.frame = frame;
            }
            
          
            
            //最大移动距离
            if (_vc.view.frame.origin.x >= WIDTH-50) {
//                _vc.view.center = CGPointMake(WIDTH-50, HEIGHT/2);
                CGRect frame = _vc.view.frame;
                frame.origin.x = WIDTH-50;
                _vc.view.frame = frame;
            }else {
              _vc.view.center = CGPointMake(_vc.view.center.x + point.x/10, HEIGHT/2);
            }
            
            //最大缩放比例
            if (scale <= 0.8) {
                _vc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
            }else {
                _vc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale,scale);
            }
            
        }
    }else {
        //往左滑动，滑动一部分，消失一部分
        if (_menu.frame.origin.x + _menu.frame.size.width > 0) {
            CGRect frame = _menu.frame;
            frame.origin.x += point.x/10;
            _menu.frame = frame;
            
            if (_menu.frame.origin.x < -_menu.frame.size.width) {
                
                CGRect frame = _menu.frame;
                frame.origin.x = -_menu.frame.size.width;
                _menu.frame = frame;
            }
        }
        
        
        //主控制器的页面
//        scale =  (1 + point.x / 1400);
       
        scale = 1-(0.2/(WIDTH-50) * _vc.view.frame.origin.x);
        
        _vc.view.center = CGPointMake(_vc.view.center.x + point.x/10, HEIGHT/2);
        
        _vc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale,scale);
      
        if (_vc.view.center.x <= WIDTH/2) {
            _vc.view.center = CGPointMake(WIDTH/2, HEIGHT/2);//
        }
        
        //            [UIView animateWithDuration:0.4 animations:^{
        //                 _vc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
        //            }];

//            else {
//
//            [UIView animateWithDuration:0.4 animations:^{
        
//            }];
        
//        }
        
        
        
        NSLog(@"scale = %f",scale);
    }
    x++;
    
    
    NSLog(@"rec.view = %@",rec.view);
    
    NSLog(@"point.x = %f,rec.origin.x = %f,_menu.frame.origin.x = %f,x=%f,",point.x,rec.view.frame.origin.x,_menu.frame.origin.x,x);
//    vc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);;
//    vc.view.center = CGPointMake(WIDTH, HEIGHT/2);
    
    
    
//     [_menu trigger];
}


@end
