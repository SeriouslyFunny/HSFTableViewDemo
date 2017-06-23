//
//  HSFTableView.m
//  HSFDemo
//
//  Created by JuZhenBaoiMac on 2017/6/22.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFTableView.h"

@implementation HSFTableView

/**
 同时识别多个手势
 
 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
