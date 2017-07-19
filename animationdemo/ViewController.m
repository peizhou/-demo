//
//  ViewController.m
//  animationdemo
//
//  Created by zhoupei on 2017/7/10.
//  Copyright © 2017年 zhoupei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(strong, nonatomic) CAShapeLayer * mainLayer;
@property(strong, nonatomic) CAGradientLayer * backLayer;
@property(strong, nonatomic) CAShapeLayer *deboLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动画demo";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //    [self initlayer];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void) initlayer:(CGPoint)A B:(CGPoint)B{
    
    while (self.view.layer.sublayers.count) {
        [self.view.layer.sublayers.lastObject removeFromSuperlayer];
    }
    
    CGPoint anchor = B.y > A.y ?CGPointMake(0.5, 0): CGPointMake(0.5, 1);
    CGFloat angle = [self angleBetweenAB:A B:B];
    
    
    _mainLayer  = [CAShapeLayer layer];
    _mainLayer.anchorPoint = anchor;
    _mainLayer.frame =  CGRectMake(A.x,A.y, 60, 60);
    _mainLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.view.layer addSublayer:_mainLayer];
    
    CGRect frame = B.y <= A.y ? CGRectMake(0, 30, 60, 30): CGRectMake(0, 0, 60, 30);
    CGRect debo_frame =  B.y <= A.y ? CGRectMake(0, 0, 60, 60): CGRectMake(0, 0, 60, 60);
    
    
    _backLayer = [CAGradientLayer layer];
    _backLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    _backLayer.startPoint = CGPointMake(0, 1);
    _backLayer.endPoint = CGPointMake(0, 0);
    _backLayer.frame = frame;
    _backLayer.backgroundColor = [UIColor redColor].CGColor;
    _backLayer.anchorPoint = anchor;
    _backLayer.frame = frame;
    [_mainLayer addSublayer:_backLayer];
    
    _deboLayer = [CAShapeLayer layer];
    _deboLayer.frame = debo_frame;
    _deboLayer.contents =  (__bridge id _Nullable )[UIImage imageNamed:@"db35_robot"].CGImage;
    
    [_mainLayer addSublayer:_deboLayer];
    
    _mainLayer.transform = CATransform3DMakeRotation( angle, 0, 0, [self isClockWise:A B:B] ? 1: -1);
    [self animate:A B:B];
    
}

/**
 是否顺时针
 
 @param A a
 @param B b
 @return 是否顺时针
 */
-(BOOL) isClockWise:(CGPoint)A B:(CGPoint)B{
    if(A.x <= B.x){
        return (B.y <= A.y) ? YES : NO;
    }
    else{
        return (B.y <= A.y) ?NO: YES;
    }
}

/**
 以A为圆心，ab距离为半径，做园，A点的垂直点
 
 @param A a
 @param B b
 @return point
 */
-(CGPoint) verticalPointBetweenAB:(CGPoint)A B:(CGPoint)B
{
    CGFloat distance = [self distanceBetweenAB:A B:B];
    CGFloat y =  B.y >= A.y ? (A.y + distance):(A.y - distance);
    return CGPointMake(A.x, y?y:0);
}


/**
 AB点之间的距离
 
 @param A a
 @param B b
 @return distance
 */
-(CGFloat) distanceBetweenAB:(CGPoint)A B:(CGPoint)B{
    CGFloat dis =  sqrt(powf(B.x - A.x, 2)  + powf(B.y-A.y, 2));
    return dis;
}

/**
 A点B点形成的角度
 
 @param A a
 @param B b
 @return angle
 */
-(CGFloat) angleBetweenAB:(CGPoint)A B:(CGPoint)B{
    return asinf(fabs((B.x - A.x))/[self distanceBetweenAB:A B:B]);
    
}
-(void) viewDidAppear:(BOOL)animated{
    
    
    NSArray *array =   @[@[[NSValue valueWithCGPoint:CGPointMake(45, 500) ],[NSValue valueWithCGPoint:CGPointMake(329,100)]],
                         @[[NSValue valueWithCGPoint:CGPointMake(45, 100) ],[NSValue valueWithCGPoint:CGPointMake(329,400)]],
                         @[[NSValue valueWithCGPoint:CGPointMake(345, 100) ],[NSValue valueWithCGPoint:CGPointMake(100, 500)]],
                         @[[NSValue valueWithCGPoint:CGPointMake(299, 500) ],[NSValue valueWithCGPoint:CGPointMake(100,100)]],
                         @[[NSValue valueWithCGPoint:CGPointMake(100, 100) ],[NSValue valueWithCGPoint:CGPointMake(300, 100)]],
                         @[[NSValue valueWithCGPoint:CGPointMake(100, 100) ],[NSValue valueWithCGPoint:CGPointMake(100, 500)]],
                         @[[NSValue valueWithCGPoint:CGPointMake(200, 500) ],[NSValue valueWithCGPoint:CGPointMake(200, 100)]],
                         @[[NSValue valueWithCGPoint:CGPointMake(300, 500) ],[NSValue valueWithCGPoint:CGPointMake(10,500)]]];
    
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 *idx* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initlayer:[obj[0] CGPointValue] B:[obj[1] CGPointValue]];
        });
    }];
}

-(void) animate:(CGPoint)A B:(CGPoint)B{
    
    CGPoint A1 = [self verticalPointBetweenAB:A B:B];
    CGFloat distance = [self distanceBetweenAB:A B:B];
    
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"bounds";
    animation.beginTime = CACurrentMediaTime();
    animation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGRect:_backLayer.bounds];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 60, fabs(A1.y -A.y))];
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 2.0f;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    [_backLayer addAnimation:animation forKey:@"sd"];
    
    CABasicAnimation * deboPositionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    deboPositionAnimation.fromValue = @(30);
    deboPositionAnimation.toValue = B.y > A.y ?@(distance) :@(-distance +60);
    deboPositionAnimation.fillMode = kCAFillModeForwards;
    deboPositionAnimation.duration = 2.0f;
    deboPositionAnimation.repeatCount = 1;
    deboPositionAnimation.removedOnCompletion = NO;
    [_deboLayer addAnimation:deboPositionAnimation forKey:@"asdasdasd"];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
