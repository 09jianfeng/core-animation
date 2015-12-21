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
