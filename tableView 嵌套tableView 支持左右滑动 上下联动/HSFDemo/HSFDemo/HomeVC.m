//
//  HomeVC.m
//  HSFDemo
//
//  Created by JuZhenBaoiMac on 2017/6/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HomeVC.h"

#import "DemoVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:92/255.0 green:172/255.0 blue:248/255.0 alpha:1];// 设置导航栏背景颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];// 设置导航栏文字字体大小 文字的颜色
    self.navigationItem.title = @"Home";
}



- (IBAction)show:(UIButton *)sender {
    DemoVC *vc = [[DemoVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
