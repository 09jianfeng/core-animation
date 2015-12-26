//
//  CG_VS_CA.h
//  CoreAnimationTest
//
//  Created by 陈建峰 on 15/12/22.
//  Copyright © 2015年 DouJinSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CG_VS_CA : UIView

@end

/*
 “这样实现的问题在于，我们画得越多，程序就会越慢。因为每次移动手指的时候都会重绘整个贝塞尔路径（UIBezierPath），随着路径越来越复杂，每次重绘的工作就会增加，直接导致了帧数的下降。看来我们需要一个更好的方法了。
 
     Core Animation为这些图形类型的绘制提供了专门的类，并给他们提供硬件支持（第六章『专有图层』有详细提到）。CAShapeLayer可以绘制多边形，直线和曲线。CATextLayer可以绘制文本。CAGradientLayer用来绘制渐变。这些总体上都比Core Graphics更快，同时他们也避免了创造一个寄宿图。
 
     如果稍微将之前的代码变动一下，用CAShapeLayer替代Core Graphics，性能就会得到提高（见清单13.2）.虽然随着路径复杂性的增加，绘制性能依然会下降，但是只有当非常非常浮躁的绘制时才会感到明显的帧率差异。”
 
 摘录来自: 钟声. “ios核心动画高级技巧”。 iBooks.
 
 看 CG_VS_CA_performBettor
 */