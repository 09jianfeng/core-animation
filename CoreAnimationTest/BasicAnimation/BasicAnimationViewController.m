//
//  BasicAnimationViewController.m
//  UIKitCAlayer
//
//  Created by JFChen on 15/12/8.
//  Copyright © 2015年 HuaiNan. All rights reserved.
//

#import "BasicAnimationViewController.h"

@interface BasicAnimationViewController ()
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation BasicAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //test cabasicanimation or keyanimation
    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f,50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.view.layer addSublayer:self.colorLayer];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(50, 250, 100, 50);
    [button addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
}

- (void)changeColor
{
    /* CABasicAnimation
    //create a new random color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //create a basic animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)color.CGColor;
    animation.delegate = self;
    
    //让动画结束后不回到原来f的状态
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    //apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];
     */
    
    
    /* CAKeyframeAnimation 沿着关键帧来做动画
    //create a keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    //让动画结束后不回到原来的状态
//    animation.fillMode=kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
    
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor];
    //apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];
     */
    
    
    //create a path    CAKeyframeAnimation 沿着CGPath画的路径来执行动画
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    //add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 64, 64);
    shipLayer.position = CGPointMake(0, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed: @"Ship.png"].CGImage;
    shipLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.view.layer addSublayer:shipLayer];
    //create the keyframe animation
    CAKeyframeAnimation *animationBezier = [CAKeyframeAnimation animation];
    animationBezier.keyPath = @"position";
    animationBezier.duration = 4.0;
    animationBezier.path = bezierPath.CGPath;
    
    //设置了下面这个属性会使得图片的运行方向与路径向切
    animationBezier.rotationMode = kCAAnimationRotateAuto;
    
    //让动画结束后不回到原来的状态
    animationBezier.fillMode=kCAFillModeForwards;
    animationBezier.removedOnCompletion = NO;
    
    [shipLayer addAnimation:animationBezier forKey:nil];
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    //set the backgroundColor property to match animation toValue
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
