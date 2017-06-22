//
//  VC2.m
//  HSFDemo
//
//  Created by JuZhenBaoiMac on 2017/6/22.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "VC2.h"

#import "VC2Cell.h"

@interface VC2 ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation VC2

#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VC2Cell class]) bundle:nil] forCellReuseIdentifier:@"VC2Cell"];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VC2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"VC2Cell" forIndexPath:indexPath];
    cell.title.text = [NSString stringWithFormat:@"TITLE(%ld)",(long)indexPath.row];
    return cell;
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        if (!self.vcCanScroll) {
            scrollView.contentOffset = CGPointZero;
        }
        if (scrollView.contentOffset.y <= 0) {
            self.vcCanScroll = NO;
            scrollView.contentOffset = CGPointZero;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeVCScrollState" object:nil userInfo:nil];//到顶通知父视图改变状态
        }
        self.tableView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
    }
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
