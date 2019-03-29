//
//  CHHomeSidebar.m
//  anbang_ios
//
//  Created by 王奥东 on 17/3/22.
//  Copyright © 2017年 ch. All rights reserved.
//

#import "CHHomeSidebar.h"


static NSInteger kMenuBlankWidth = 30;

@implementation CHHomeSidebar{
    //动画绘制时，上方的View
    UIView *_helperSideView;
    //动画绘制时，中间的View
    UIView *_helperCenterView;

    CADisplayLink *_displayLink;
    //视觉效果化View,背后模板
    UIVisualEffectView *_blurView;
    //保存主窗口
    UIWindow *_keyWindow;
    //用于供外界调用时判断动画开启的Bool值
    BOOL _triggered;
    //用于绘制圆弧的最大x值
    CGFloat _diff;
    //按钮高度
    CGFloat menuButtonHeight;
    //填充颜色
    UIColor *_menuColor;
    
    

    //自身的frame
    CGRect _myselfFrame;
}


-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _keyWindow = [[UIApplication sharedApplication]keyWindow];
        
        //视觉效果View,背景模板
        _blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurView.frame = _keyWindow.frame;
        _blurView.alpha = 0;
        
        _helperSideView = [[UIView alloc] initWithFrame:CGRectMake(_keyWindow.frame.size.width+40, 0, 40, 40)];
        _helperSideView.hidden = YES;
        [_keyWindow addSubview:_helperSideView];
        
        _helperCenterView = [[UIView alloc] initWithFrame:CGRectMake(_keyWindow.frame.size.width+40, CGRectGetHeight(_keyWindow.frame)/2-20, 40, 40)];
        _helperCenterView.hidden = YES;
        [_keyWindow addSubview:_helperCenterView];
        
        //初始化时务必放在屏幕外面，开启动画时再放到内部
        CGRect frame = self.frame;
        frame.origin.x = _keyWindow.frame.size.width+self.frame.size.width + kMenuBlankWidth;
        frame.size.width = self.frame.size.width+kMenuBlankWidth;
        self.frame = frame;
        _myselfFrame = self.frame;
     
        [_keyWindow insertSubview:self belowSubview:_helperCenterView];
    }
     return self;
}

#pragma mark - 供外界调用，开启动画
-(void)trigger{
    
    if (!_triggered) {
        
        [_keyWindow insertSubview:_blurView belowSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = (CGRect){CGPointMake(KCurrWidth-self.frame.size.width, 0),self.frame.size};
        }];
        [self beforeAnimation];
        //弹簧动画
        //从当前状态开始允许用户交互,弹开压制0.5秒,速度0.9
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.9 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            _helperSideView.center = CGPointMake(_keyWindow.center.x, _helperSideView.frame.size.height/2);
            
        } completion:^(BOOL finished) {
            [self finishAnimation];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            _blurView.alpha = 0.6;
        }];
        [self beforeAnimation];
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            _helperCenterView.center = _keyWindow.center;
            
        } completion:^(BOOL finished) {
            if (finished) {
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToUntrigger)];
                [_blurView addGestureRecognizer:tapGestureRecognizer];
                [self finishAnimation];
            }
        }];
        _triggered = YES;
    }else{
        [self tapToUntrigger];
    }
}

#pragma mark - 按钮被点击、UIVisualEffectView被点击、_triggered为YES后点击右上角菜单时

-(void)tapToUntrigger{
    //修改自身frame回到屏幕左侧
    [UIView animateWithDuration:0.3 animations:^{
        self.frame =_myselfFrame;
    }];
    //而后通过此方法开启DisplayLink
    //在执行方法里绘制圆弧与背景
    [self beforeAnimation];
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.9 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
       
        _helperSideView.center = CGPointMake(KCurrWidth - _helperSideView.frame.size.width/2, _helperSideView.frame.size.height/2);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    //隐藏视觉效果化View，UIVisualEffectView
    [UIView animateWithDuration:0.3 animations:^{
        _blurView.alpha = 0.0f;
    }];
    
    //再度开启DisplayLink
    [self beforeAnimation];
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        _helperCenterView.center = CGPointMake(KCurrWidth-_helperSideView.frame.size.height/2, CGRectGetHeight(_keyWindow.frame)/2);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    _triggered = NO;
}



#pragma mark - 动画开始前的准备
-(void)beforeAnimation{
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark - 动画结束
-(void)finishAnimation{
    
    [_displayLink invalidate];
    _displayLink = nil;
}


#pragma mark - displayLink的执行方法
-(void)displayLinkAction{
    
    //最上方的
    CALayer *sideHelperPresentationLayer = [_helperSideView.layer presentationLayer];
    //中间的
    CALayer *centerHelperPresentationLayer = [_helperCenterView.layer presentationLayer];
    
    CGRect sideRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    
    _diff = sideRect.origin.x - centerRect.origin.x;
    
    NSLog(@"_diff = %f",_diff);
    
    [self setNeedsDisplay];
    
}
#pragma mark - 图形绘制drawRect
-(void)drawRect:(CGRect)rect{
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    [path moveToPoint:CGPointMake(self.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(kMenuBlankWidth, 0)];
    [path addQuadCurveToPoint:CGPointMake(kMenuBlankWidth, self.frame.size.height) controlPoint:CGPointMake(kMenuBlankWidth+_diff, _keyWindow.frame.size.height/2)];
    
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path closePath];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    _menuColor = [UIColor blueColor];
    [_menuColor set];
    CGContextFillPath(context);
    
}





@end
