//
//  CG_VS_CA_perfromBetter.m
//  CoreAnimationTest
//
//  Created by 陈建峰 on 15/12/23.
//  Copyright © 2015年 DouJinSDK. All rights reserved.
//

#import "CG_VS_CA_perfromBetter.h"

@implementation CG_VS_CA_perfromBetter
+(Class)layerClass{
    //this makes our view create a cashapelayer
    //instead of a calayer for its backing layer
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //create a mutable path
        self.path = [[UIBezierPath alloc] init];
        
        //configure the layer
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 5;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //move the path drawing cursor to the starting point
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //add a new line segment to our path
    [self.path addLineToPoint:point];
    
    //update the layer with a copy of the path
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
}
@end
