//
//  LayerCornerOrShadow.m
//  UIKitCAlayer
//
//  Created by 陈建峰 on 15/11/27.
//  Copyright © 2015年 HuaiNan. All rights reserved.
//

#import "LayerCornerOrShadow.h"
#import <UIKit/UIKit.h>

@interface LayerCornerOrShadow()
@end

@implementation LayerCornerOrShadow

#pragma mark - 当需要用到裁剪效果、与阴影效果共存时
//当阴影和裁剪扯上关系的时候就有一个头疼的限制：阴影通常就是在Layer的边界之外，如果你开启了masksToBounds属性，所有从图层中突出来的内容都会被才剪掉。如果我们在我们之前的边框示例项目中增加图层的阴影属性时，你就会发现问题所在。从技术角度来说，这个结果是可以是可以理解的，但确实又不是我们想要的效果。如果你想沿着内容裁切，你需要用到两个图层：一个只画阴影的空的外图层，和一个用masksToBounds裁剪内容的内图层
- (void)testSubViewShadowAndCorner:(UIView *)fatherView{
    UIView *shadowLayer = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    UIView *layerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    layerView1.backgroundColor = [UIColor whiteColor];
    [shadowLayer addSubview:layerView1];
    UIView *layerViewRed = [[UIView alloc] initWithFrame:CGRectMake(-50, -50, 100, 100)];
    layerViewRed.backgroundColor = [UIColor redColor];
    [layerView1 addSubview:layerViewRed];
    
    layerView1.layer.cornerRadius = 15.0;
    layerView1.layer.borderColor = [UIColor blackColor].CGColor;
    layerView1.layer.borderWidth = 3.0;
    layerView1.layer.masksToBounds = YES;
    
    shadowLayer.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.layer.shadowRadius = 5.0;
    shadowLayer.layer.shadowOffset = CGSizeMake(5.0, 5.0);
    shadowLayer.layer.masksToBounds = NO;
    shadowLayer.layer.shadowOpacity = 0.5;
    shadowLayer.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.0];
    
    [fatherView addSubview:shadowLayer];
}

#pragma mark - UIImageView不能同时设置圆角与阴影效果的讨论、UIView不会出现这个问题
-(void)setViewCornerAndShadow:(UIView *)fatherView{
    /*
     这样可以同时实现圆角跟阴影，只要不给UIimageView的image直接赋值，就可以
     */
    //    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 150, 150)];
    //    imgView.backgroundColor = [UIColor grayColor];
    //    UIImage *image = [UIImage imageNamed:@"suolong.jpg"];
    //    imgView.layer.backgroundColor = [UIColor colorWithPatternImage:image].CGColor;
    //
    //    // Rounded corners.
    //    imgView.layer.cornerRadius = 10;
    //    // A thin border.
    //    imgView.layer.borderColor = [UIColor blackColor].CGColor;
    //    imgView.layer.borderWidth = 0.3;
    //    imgView.clipsToBounds = NO;
    //
    //    // Drop shadow.
    //    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imgView.layer.shadowOpacity = 1.0;
    //    imgView.layer.shadowRadius = 7.0;
    //    imgView.layer.shadowOffset = CGSizeMake(0, 4);
    //    [fatherView addSubview:imgView];
    
    
    
    //------------------------不调用clipsToBounds的话就显示不了圆角,如果有给UIImageView赋予图片的话。
    /*原因：
     我们对该layer进行了圆角设置，但是其实是仅仅是对父图层进行了处理，但是子图层的圆角并没有去设置导致的。这个时候就需要设置masksToBounds去对子图层剪切。
     ！！！疑问，子图层这个说法有点问题，因为去打印的时候没发现主layer上面还有其他的layer
     */
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"suolong.jpg"]];
    //    imageView.frame = CGRectMake(50, 50, 150, 150);
    //    imageView.layer.cornerRadius = 10.0;
    //    imageView.layer.masksToBounds = YES;  //这里不掉用的话会出不来圆角效果
    //为了显示圆角效果就要对子layer也设置
    
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    //layer.contents的赋值方法应该会导致再layer上再加一层layer来放image。因为这样圆角不能跟阴影同时存在
    //    imageView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"suolong.jpg"].CGImage);
    imageView.layer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"suolong.jpg"]].CGColor; //这个方法不会对图片进行缩放，但是不会影响到圆角的效果。
    imageView.frame = CGRectMake(50, 200, 150, 150);
    imageView.layer.cornerRadius = 10.0;
    
    
    [fatherView addSubview:imageView];
    
}



#pragma mark - 绘画圆角效果的优化方案
-(void)bestPerformToSetCorner:(UIImageView *)imageView{
    //-----------方案一
    //http://stackoverflow.com/questions/11049016/cliptobounds-and-maskstobounds-performance-issue  github地址
//    view.layer.shouldRasterize = YES; 光栅化视图，会被分配一个缓存。不至于说每次都是重新粉刷
//    view.layer.rasterizationScale = view.window.screen.scale; // or [UIScreen mainScreen]
    
    //-----------方案二
    //http://stackoverflow.com/questions/17593524/using-cornerradius-on-a-uiimageview-in-a-uitableviewcell
    //或者，直接转换UIImage，用贝塞尔曲线
    // Get your image somehow
    UIImage *image = [UIImage imageNamed:@"suolong.jpg"];
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:10.0] addClip];
    // Draw your image
    [image drawInRect:imageView.bounds];
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
}

#pragma mark - 阴影效果的优化方案
/*
 我们已经知道图层阴影并不总是方的，而是从图层内容的形状继承而来。这看上去不错，但是实时计算阴影也是一个非常消耗资源的，尤其是图层有多个子图层，每个图层还有一个有透明效果的寄宿图的时候。
 
 如果你事先知道你的阴影形状会是什么样子的，你可以通过指定一个shadowPath来提高性能。shadowPath是一个CGPathRef类型（一个指向CGPath的指针）。CGPath是一个Core Graphics对象，用来指定任意的一个矢量图形。我们可以通过这个属性单独于图层形状之外指定阴影的形状。
 
 如果是一个矩形或者是圆，用CGPath会相当简单明了。但是如果是更加复杂一点的图形，UIBezierPath类会更合适，它是一个由UIKit提供的在CGPath基础上的Objective-C包装类。
 */
- (void) bestPerformToSetShadow:(UIView *)fatherView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"suolong.jpg"].CGImage);
    [fatherView addSubview:view];
    
    //create a square shadow
    CGMutablePathRef squarePath = CGPathCreateMutable();
    CGPathAddRect(squarePath, NULL, view.bounds);
    view.layer.shadowPath = squarePath; CGPathRelease(squarePath);
}






@end
