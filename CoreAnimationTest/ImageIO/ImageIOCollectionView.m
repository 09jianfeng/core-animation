//
//  ImageIOCollectionView.m
//  CoreAnimationTest
//
//  Created by 陈建峰 on 15/12/26.
//  Copyright © 2015年 DouJinSDK. All rights reserved.
//

#import "ImageIOCollectionView.h"

@interface ImageIOCollectionView()
@property (nonatomic, copy) NSArray *imagePaths;

//先预加载前一个图片跟后一个图片
@property (nonatomic, copy) UIImage *preUIImage;
@property (nonatomic, copy) UIImage *nextUIImage;
@end

@implementation ImageIOCollectionView
- (void)viewDidLoad
{
    //set up data
    self.imagePaths =
    [[NSBundle mainBundle] pathsForResourcesOfType:@"JPG" inDirectory:@""];
    //register cell class
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imagePaths count];
}


/*
 最后一种方式就是使用UIKit加载图片，但是需要立刻将它绘制到CGContext中去。图片必须要在绘制之前解压，所以就要立即强制解压。这样的好处在于绘制图片可以在后台线程（例如加载本身）中执行，而不会阻塞UI。
 
 有两种方式可以为强制解压提前渲染图片：
 
 将图片的一个像素绘制成一个像素大小的CGContext。这样仍然会解压整张图片，但是绘制本身并没有消耗任何时间。这样的好处在于加载的图片并不会在特定的设备上为绘制做优化，所以可以在任何时间点绘制出来。同样iOS也就可以丢弃解压后的图片来节省内存了。
 
 将整张图片绘制到CGContext中，丢弃原始的图片，并且用一个从上下文内容中新的图片来代替。这样比绘制单一像素那样需要更加复杂的计算，但是因此产生的图片将会为绘制做优化，而且由于原始压缩图片被抛弃了，iOS就不能够随时丢弃任何解压后的图片来节省内存了。
 
 需要注意的是苹果特别推荐了不要使用这些诡计来绕过标准图片解压逻辑（所以也是他们选择用默认处理方式的原因），但是如果你使用很多大图来构建应用，那如果想提升性能，就只能和系统博弈了。
 */

/*
 如果不使用+imageNamed:，那么把整张图片绘制到CGContext可能是最佳的方式了。尽管你可能认为多余的绘制相较别的解压技术而言性能不是很高，但是新创建的图片（在特定的设备上做过优化）可能比原始图片绘制的更快。
 
 同样，如果想显示图片到比原始尺寸小的容器中，那么一次性在后台线程重新绘制到正确的尺寸会比每次显示的时候都做缩放会更有效
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //dequeue cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                           forIndexPath:indexPath];
    //add image view
    const NSInteger imageTag = 99;
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:imageTag];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame: cell.contentView.bounds];
        imageView.tag = imageTag;
        [cell.contentView addSubview:imageView];
    }
    //tag cell with index and clear current image
    cell.tag = indexPath.row;
    imageView.image = nil;
    //switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //load image
        NSInteger index = indexPath.row;
        NSString *imagePath = self.imagePaths[index];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        //redraw image using device context
        //这里强制把加载到内存的图片先解压了，而不是通过设置image的方式在主线程要绘图的时候才解压
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, YES, 0);
        [image drawInRect:imageView.bounds];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //set image on main thread, but only if index still matches up
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index == cell.tag) {
                imageView.image = image;
            }
        });
    });
    return cell;
}

-(void)loadPreImage:(NSIndexPath *)indexPath rect:(CGRect)rect{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSInteger index = fmin(0, indexPath.row - 1);
        NSString *imagePath = self.imagePaths[index];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        //redraw image using device context
        //这里强制把加载到内存的图片先解压了，而不是通过设置image的方式在主线程要绘图的时候才解压
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
}

-(void)loadNextImage:(NSIndexPath *)indexPath rect:(CGRect)rect{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSInteger index = fmax(indexPath.row + 1, self.imagePaths.count - 1);
        NSString *imagePath = self.imagePaths[index];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        //redraw image using device context
        //这里强制把加载到内存的图片先解压了，而不是通过设置image的方式在主线程要绘图的时候才解压
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
}

@end


