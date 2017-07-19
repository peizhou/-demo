//
//  IndexViewController.m
//  animationdemo
//
//  Created by zhoupei on 2017/7/18.
//  Copyright © 2017年 zhoupei. All rights reserved.
//
#import "IndexViewController.h"
#import "ViewController.h"
typedef NS_ENUM(NSInteger, Direction){
    direction_down = 0,
    direction_up = 1,
    direction_left = 2,
    direction_right= 3,
};
@interface IndexViewController ()<CAAnimationDelegate>
@property(strong, nonatomic) CAShapeLayer * deboLayer;
@property(strong, nonatomic) CAShapeLayer * backLayer;
@property(strong, nonatomic) CAGradientLayer * gradientLayer;
@property(assign, nonatomic) CGPoint startPoint;
@property(assign, nonatomic) Direction direction;
@property(strong, nonatomic) UIView * backview;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //
    
    
    
    
    _backview = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width , self.view.frame.size.height)];;
    [self.view addSubview:_backview];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 90, 100, 40)];
    [btn setTitle:@"直线（老）" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(hehe) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:btn aboveSubview:_backview];
    
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 140, 100, 40)];
    [btn1 setTitle:@"点到点随机" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 addTarget:self action:@selector(re) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:btn1 aboveSubview:_backview];
    // Do any additional setup after loading the view.
}

-(void) re{
    ViewController *vc = [[ViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void) initLayersWithStartPoint:(CGPoint) point
{
    while (_backview.layer.sublayers.count) {
        [_backview.layer.sublayers.lastObject removeFromSuperlayer];
    }
    self.startPoint = point;
    
    _backLayer  = [CAShapeLayer layer];
    _backLayer.anchorPoint = CGPointMake(0, 0);
    _backLayer.frame = CGRectMake(point.x-30, point.y+30, 60, 60);
    _backLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [_backview.layer addSublayer:_backLayer];
    
    _deboLayer = [CAShapeLayer layer];
    _deboLayer.frame = CGRectMake(0, 0, 60, 60);
    _deboLayer.contents =  (__bridge id _Nullable )[UIImage imageNamed:@"db35_robot"].CGImage;
    
    [_backLayer addSublayer:_deboLayer];
    
    
    _gradientLayer = [CAGradientLayer layer];
    
    [_backLayer insertSublayer:_gradientLayer below:_deboLayer];
    
    
//    _backLayer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
}


-(void) animateToPoint:(CGPoint) toPoint{
    
    
    NSString * deboAnimationKeyPath;
    CGFloat deboAnimationFromValue;
    CGFloat deboAnimationToValue;
    CGFloat distance = [self distanceBetweenPoints: self.startPoint second: toPoint];
    CGRect endbounds = CGRectZero;
    CGRect endbounrd1 = CGRectZero;
    float x1 = _backLayer.frame.origin.x;
    float y1 = _backLayer.frame.origin.y;
    
    float x2 = _gradientLayer.frame.origin.x;
    float y2 = _gradientLayer.frame.origin.y;
    if(self.startPoint.x == toPoint.x)
    {
        
        
        
        self.direction = toPoint.y > self.startPoint.y ? direction_down: direction_up;
        
        if(self.direction == direction_up)
            _gradientLayer.frame = CGRectMake(0, 30, 60, 30);
        else
            _gradientLayer.frame = CGRectMake(0, 0, 60, 30);
        
        
        x2 = _gradientLayer.frame.origin.x;
        y2 = _gradientLayer.frame.origin.y;
        
        
        _backLayer.anchorPoint = self.direction == direction_down  ?CGPointMake(0.5, 0): CGPointMake(0.5,1);
        
        
        _gradientLayer.anchorPoint = self.direction == direction_down ? CGPointMake(0.5, 0):CGPointMake(0.5, 0);
        
        endbounds = CGRectMake(0, 0,_backLayer.frame.size.width, distance + _backLayer.frame.size.height);
        endbounrd1 = CGRectMake(0, 0,_gradientLayer.frame.size.width , distance + _gradientLayer.frame.size.height);
        deboAnimationKeyPath = @"position.y";
        deboAnimationFromValue = _deboLayer.position.y;
        deboAnimationToValue = _deboLayer.position.y + distance;
        if(self.direction == direction_up)
            deboAnimationToValue = _deboLayer.position.y;
        
        
    }
    else if (self.startPoint.y == toPoint.y)
    {
        
        self.direction = toPoint.x > self.startPoint.x ? direction_right: direction_left;
        
        if(self.direction == direction_left)
            
            _gradientLayer.frame = CGRectMake(30, 0, 30, 60);
        else
            _gradientLayer.frame = CGRectMake(0, 0, 30, 60);
        
        x2 = _gradientLayer.frame.origin.x;
        y2 = _gradientLayer.frame.origin.y;
        
        
        
        _backLayer.anchorPoint = self.direction == direction_right  ?CGPointMake(0, 0.5): CGPointMake(1,0.5);
        
        _gradientLayer.anchorPoint = self.direction == direction_right  ?CGPointMake(0, 0.5): CGPointMake(0,0.5);
        
        endbounds = CGRectMake(0, 0,distance + _backLayer.frame.size.width,_backLayer.frame.size.height);
        endbounrd1 = CGRectMake(0, 0, distance + _gradientLayer.frame.size.width, _gradientLayer.frame.size.height);
        deboAnimationKeyPath = @"position.x";
        deboAnimationFromValue = _deboLayer.position.x;
        deboAnimationToValue = _deboLayer.position.x + distance;
        if (self.direction ==direction_left)
            deboAnimationToValue = _deboLayer.position.x;
    }
    
    
    
    [_backLayer setFrame:CGRectMake(x1, y1, _backLayer.frame.size.width, _backLayer.frame.size.height)];
    [_gradientLayer setFrame:CGRectMake(x2, y2, _gradientLayer.frame.size.width, _gradientLayer.frame.size.height)];
    
    CABasicAnimation * transform = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transform.removedOnCompletion = NO;
    transform.fillMode = kCAFillModeForwards;
    transform.fromValue = @(0);
    if(self.direction == direction_left)
    {
        transform.toValue = @(-M_PI_2);
        
    }
    if(self.direction == direction_right)
    {
        transform.toValue = @(M_PI_2);
        
    }
    if(self.direction == direction_up)
    {
        transform.toValue = @(0);
        
    }
    if(self.direction == direction_down)
    {
        transform.toValue = @(M_PI);
        
    }
    transform.duration = 0.2;
    [_deboLayer addAnimation:transform forKey:@""];
    
    
    CABasicAnimation * boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:_backLayer.bounds];
    boundsAnimation.toValue = [NSValue valueWithCGRect:endbounds];
    
    CAAnimationGroup * group =[CAAnimationGroup animation];
    group.removedOnCompletion=NO;
    group.fillMode=kCAFillModeForwards;
    group.beginTime = CACurrentMediaTime() + 0.2;
    group.animations =[NSArray arrayWithObjects: boundsAnimation, nil];
    group.duration =1;
    group.delegate = self;
    [_backLayer addAnimation:group forKey:@"frame"];
    //
    
    
    
    
    CABasicAnimation * deboPositionAnimation = [CABasicAnimation animationWithKeyPath:deboAnimationKeyPath];
    deboPositionAnimation.fromValue = @(deboAnimationFromValue);
    deboPositionAnimation.toValue = @(deboAnimationToValue);
    
    CAAnimationGroup * group0=[CAAnimationGroup animation];
    group0.removedOnCompletion=NO;
    group0.beginTime =CACurrentMediaTime() + 0.2;
    
    group0.fillMode=kCAFillModeForwards;
    group0.animations =[NSArray arrayWithObjects: deboPositionAnimation, nil];
    group0.duration =1;
    group0.delegate = self;
    [_deboLayer addAnimation:group0 forKey:@"debao"];
    
    
    
    
    //
    CABasicAnimation * boundsAnimation1 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation1.fromValue = [NSValue valueWithCGRect:_gradientLayer.bounds];
    boundsAnimation1.toValue = [NSValue valueWithCGRect: endbounrd1];
    
    CAAnimationGroup * group1 =[CAAnimationGroup animation];
    group1.beginTime = CACurrentMediaTime() + 0.2;
    group1.removedOnCompletion=NO;
    group1.fillMode=kCAFillModeForwards;
    group1.animations =[NSArray arrayWithObjects: boundsAnimation1, nil];
    group1.duration =1;
    group1.delegate = self;
    [_gradientLayer addAnimation:group1 forKey:@"gradientLayer"];
    
}

-(void) animationDidStart:(CAAnimation *)anim
{
    if(anim == [_backLayer animationForKey:@"frame"])
    {
        _gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 1);
    }
}

-(void) removeGr
{
    
    CGPoint startPoint = _gradientLayer.presentationLayer.position;
    
    CGPoint enpoint = CGPointMake(_gradientLayer.position.x, 30);
    CGRect startbounds = _gradientLayer.presentationLayer.bounds;
    CGRect endbounds = CGRectZero;
    if(self.direction == direction_up || self.direction == direction_down)
        
        endbounds  = CGRectMake(0, 0, _gradientLayer.frame.size.width, 0);
    else
        endbounds = CGRectMake(0, 0, 0, _gradientLayer.frame.size.height);
    
    CABasicAnimation * baseAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    baseAnimation.fromValue = [NSValue valueWithCGPoint:startPoint] ;
    baseAnimation.toValue = [NSValue valueWithCGPoint:enpoint] ;
    
    CABasicAnimation * boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    boundsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:startbounds] ;
    boundsAnimation.toValue = [NSValue valueWithCGRect:endbounds] ;
    
    CAAnimationGroup * group =[CAAnimationGroup animation];
    group.removedOnCompletion=NO;
    group.fillMode=kCAFillModeForwards;
    group.animations =[NSArray arrayWithObjects:baseAnimation, boundsAnimation, nil];
    group.duration = 0.2;
    group.delegate = self;
    [_gradientLayer addAnimation:group forKey:@"remove"];
}


-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(anim == [_backLayer animationForKey:@"frame"])
    {
        [self removeGr];
    }
    else if(anim == [_gradientLayer animationForKey:@"remove"] )
    {
        //        [self.backLayer removeFromSuperlayer];
    }
}


-(CGFloat)distanceBetweenPoints:(CGPoint)firstp second:(CGPoint)secondp

{
    
    CGFloat deltaX = secondp.x - firstp.x;
    
    CGFloat deltaY = secondp.y - firstp.y;
    
    return sqrt(deltaX*deltaX + deltaY*deltaY );
    
}



-(void) hehe


{
  CGFloat  SCREENHEIGHT = self.view.frame.size.height;
    NSArray * points = @[[NSValue valueWithCGPoint:CGPointMake(100, SCREENHEIGHT-200)], [NSValue valueWithCGPoint:CGPointMake(300, SCREENHEIGHT-200)], [NSValue valueWithCGPoint:CGPointMake(300, 100)], [NSValue valueWithCGPoint:CGPointMake(100, 100)], [NSValue valueWithCGPoint:CGPointMake(100, 400)], [NSValue valueWithCGPoint:CGPointMake(300, 400)], [NSValue valueWithCGPoint:CGPointMake(300, 100)]];
    for(NSInteger i=0; i< points.count-1; i++)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5*i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initLayersWithStartPoint:[(NSValue*)points[i] CGPointValue]];
            [self animateToPoint:[(NSValue*)points[i+1] CGPointValue]];
        });
    }
}
-(void) viewWillAppear:(BOOL)animated
{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
