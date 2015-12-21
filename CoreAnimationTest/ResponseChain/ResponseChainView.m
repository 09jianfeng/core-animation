//
//  ResponseChain.m
//  UIKitCAlayer
//
//  Created by 陈建峰 on 15/11/27.
//  Copyright © 2015年 HuaiNan. All rights reserved.
//

#import "ResponseChainView.h"

@implementation ResponseChainView

/*
 -hitTest:方法同样接受一个CGPoint类型参数，而不是BOOL类型，它返回图层本身，或者包含这个坐标点的叶子节点图层。这意味着不再需要像使用-containsPoint:那样，人工地在每个子图层变换或者测试点击的坐标。如果这个点在最外面图层的范围之外，则返回nil
 layer也有这样的类
 */
//如果想要子视图超出父视图的部分响应事件
//重写该方法后可以让超出父视图范围的子视图响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }

    return view;
}


-(void)testResponseChain{
    self.frame = CGRectMake(50, 50, 100, 100);
    self.backgroundColor = [UIColor grayColor];
    self.clipsToBounds = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"suolong.jpg"]];
    imageView.frame = CGRectMake(0, 0, 150, 150);
    imageView.alpha = 0.5;
    imageView.userInteractionEnabled = YES;
    
    [self addSubview:imageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponse:)];
    [imageView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGestureBase = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponseBase:)];
    [self addGestureRecognizer:tapGestureBase];
}

-(void)tapResponse:(id)sender{
    NSLog(@"点击了imageView");
}

-(void)tapResponseBase:(id)sender{
    NSLog(@"self.view 作出了响应");
}
@end
