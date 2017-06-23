//
//  HSFNestVC.h
//  HSFDemo
//
//  Created by JuZhenBaoiMac on 2017/6/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSFBaseTableVC;
@class HSFTableView;

#define k_Header_Height 200

@interface HSFNestVC : UIViewController


-(void)setUpWithVCs:(NSArray*)VCs titles:(NSArray *)titles;
-(void)setUpHeaderImg:(NSString *)imgName;

@end
