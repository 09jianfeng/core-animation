//
//  CG_VS_CA.m
//  CoreAnimationTest
//
//  Created by 陈建峰 on 15/12/22.
//  Copyright © 2015年 DouJinSDK. All rights reserved.
//

#import "CG_VS_CA.h"

@interface CG_VS_CA()
@property(nonatomic, strong) UIBezierPath *path;
@end

@implementation CG_VS_CA
- (void)drawRect:(CGRect)rect
{
    //draw path
    [[UIColor clearColor] setFill];
    [[UIColor redColor] setStroke];
    [self.path stroke];
}

- (id)init{
    self = [super init];
    if (self) {
        //create a mutable path
        self.path = [[UIBezierPath alloc] init];
        self.path.lineJoinStyle = kCGLineJoinRound;
        self.path.lineCapStyle = kCGLineCapRound;
        self.path.lineWidth = 5;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //create a mutable path
        self.path = [[UIBezierPath alloc] init];
        self.path.lineJoinStyle = kCGLineJoinRound;
        self.path.lineCapStyle = kCGLineCapRound;
        self.path.lineWidth = 5;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //create a mutable path
        self.path = [[UIBezierPath alloc] init];
        self.path.lineJoinStyle = kCGLineJoinRound;
        self.path.lineCapStyle = kCGLineCapRound;
        self.path.lineWidth = 5;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //move the path drawing cursor to the starting point
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //add a new line segment to our path
    [self.path addLineToPoint:point];
    
    //redraw the view
    [self setNeedsDisplay];
}

@end
