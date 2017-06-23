//
//  DemoVC.m
//  HSFDemo
//
//  Created by JuZhenBaoiMac on 2017/6/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "DemoVC.h"

#import "VC1.h"
#import "VC2.h"
#import "VC3.h"

#import "UIImage+color.h"

@interface DemoVC ()

@end

@implementation DemoVC


#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Demo";
    
    VC1 *vc_1 = [[VC1 alloc]init];
    VC2 *vc_2 = [[VC2 alloc]init];
    VC3 *vc_3 = [[VC3 alloc]init];
    
    [self setUpWithVCs:@[vc_1, vc_2, vc_3] titles:@[@"商品", @"商家信息", @"评价"]];
    //需要header的话添加
    [self setUpHeaderImg:@"headerIcon"];
    
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
