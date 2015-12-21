//
//  RootTableViewController.m
//  CoreAnimationTest
//
//  Created by 陈建峰 on 15/12/21.
//  Copyright © 2015年 DouJinSDK. All rights reserved.
//

#import "RootTableViewController.h"
#import "BasicAnimationViewController.h"

#define NUMBEROFROWS 60

@implementation RootTableViewController
-(void)viewDidLoad{
    [super viewDidLoad];
}

/*
 在内存足够的情况下，软件的视图通常会一直保存在内存中，但是如果内存不够，一些没有正在显示的viewcontroller就会收到内存不够的警告，然后就会释放自己拥有的视图，以达到释放内存的目的。但是系统只会释放内存，并不会释放对象的所有权，所以通常我们需要在这里将不需要在内存中保留的对象释放所有权，也就是将其指针置为nil。
 
 这个方法通常并不会在视图变换的时候被调用，而只会在系统退出或者收到内存警告的时候才会被调用。但是由于我们需要保证在收到内存警告的时候能够对其作出反应，所以这个方法通常我们都需要去实现。
 */
-(void)viewDidUnload{
    [super viewDidUnload];
}

//你在控制器中实现了loadView方法，那么你可能会在应用运行的某个时候被内存管理控制调用。 如果设备内存不足的时候， view 控制器会收到didReceiveMemoryWarning的消息。 默认的实现是检查当前控制器的view是否在使用。如果它的view不在当前正在使用的view hierarchy里面，且你的控制器实现了loadView方法，那么这个view将被release.
//要显示的时候loadView方法将被再次调用来创建一个新的view。
//Don't read self.view in -loadView. Only set it, don't get it.
//The self.view property accessor calls -loadView if the view isn't currently loaded. There's your infinite recursion
-(void)loadView{
    UIView *view = [ [ UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    [ view setBackgroundColor:[UIColor whiteColor]] ;
    self.view = view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NUMBEROFROWS;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"rootTableViewIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"BAsicAnimation";
            break;
            
        default:
            cell.textLabel.text = @"";
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            BasicAnimationViewController *basicAnimation = [[BasicAnimationViewController alloc] init];
            [self.navigationController pushViewController:basicAnimation animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
