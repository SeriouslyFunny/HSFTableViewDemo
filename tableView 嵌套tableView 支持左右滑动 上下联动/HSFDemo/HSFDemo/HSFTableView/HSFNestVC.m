//
//  HSFNestVC.m
//  HSFDemo
//
//  Created by JuZhenBaoiMac on 2017/6/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFNestVC.h"

#import "HSFTableView.h"
#import "HSFTableCell.h"
#import "MLMSegmentManager.h"
#import "HSFBaseTableVC.h"
#import "UIImage+color.h"

@interface HSFNestVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) HSFTableView *tableView;
@property (nonatomic,strong) HSFTableCell *cell;

@property (nonatomic,strong) NSArray *childVCs;
@property (nonatomic,strong) NSArray *categoryTitles;

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@property (nonatomic,assign) BOOL canScroll;//默认刚开始是YES
@property (nonatomic,assign) CGFloat offset_y;

//header
@property (nonatomic,assign) BOOL isHaveHeader;
@property (nonatomic,strong) UIView *header;
@property (nonatomic,strong) UIImageView *headerImgView;

@end

@implementation HSFNestVC

#pragma mark -只要调用这两个方法就可以了
-(void)setUpWithVCs:(NSArray*)VCs titles:(NSArray *)titles{
    self.childVCs = VCs;
    self.categoryTitles = titles;
    [self.tableView reloadData];
}
-(void)setUpHeaderImg:(NSString *)imgName{
    self.isHaveHeader = YES;
    self.headerImgView.image = [UIImage imageNamed:imgName];
    self.tableView.tableHeaderView = self.header;
    [self.tableView reloadData];
}


#pragma mark -懒加载
-(UIView *)header{
    if (!_header) {
        _header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, k_Header_Height)];
        _header.backgroundColor = [UIColor lightGrayColor];
        self.headerImgView = [[UIImageView alloc]initWithFrame:_header.bounds];
        self.headerImgView.image = [UIImage imageNamed:@"headerIcon"];
        self.headerImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImgView.layer.masksToBounds = YES;
        [_header addSubview:self.headerImgView];
    }
    return _header;
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //配置tableView
    [self setUpTableView];
    //默认刚开始是YES
    self.canScroll = YES;
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVCScrollState:) name:@"changeVCScrollState" object:nil];
}
//配置tableView
-(void)setUpTableView{
    self.tableView = [[HSFTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFTableCell class])];
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFTableCell class]) forIndexPath:indexPath];
    [self setUpSegment];
    return self.cell;
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.height;
}

#pragma mark - 添加子控制器
- (void)setUpSegment {
//    NSArray *list = @[@"商品",
//                      @"商家信息",
//                      @"评价"];
    NSArray *list = self.categoryTitles;
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) titles:list headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    _segHead.fontScale = 1.2;
    _segHead.fontSize = 14;
    _segHead.deSelectColor = [UIColor lightGrayColor];
    _segHead.selectColor = [UIColor redColor];
    _segHead.lineScale = 1;
    _segHead.lineColor = [UIColor redColor];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, self.tableView.frame.size.height-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = YES;
    _segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.cell.contentView addSubview:_segHead];
        [self.cell.contentView addSubview:_segScroll];
    }];
}
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.childVCs.count; i++) {
        HSFBaseTableVC *vc = self.childVCs[i];
        [arr addObject:vc];
    }
    return arr;
}
#pragma mark -通知
-(void)changeVCScrollState:(NSNotification *)sender{
    self.canScroll = YES;
    for (int i = 0; i < self.childVCs.count; i++) {
        HSFBaseTableVC *vc = self.childVCs[i];
        vc.vcCanScroll = NO;
    }
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        self.offset_y = scrollView.contentOffset.y;
        NSLog(@"offset_y = %f",self.offset_y);
        //下拉放大header
        if (self.isHaveHeader) {
            CGFloat deta = ABS(self.offset_y);
            if (self.offset_y <= 0) {
                self.headerImgView.frame = CGRectMake(0, -deta, self.view.frame.size.width, k_Header_Height + deta);
            }
        }
               
        /* 关键 */
        CGFloat headerOffset = 0.0;
        if (self.isHaveHeader) {
            headerOffset = k_Header_Height;
        }else{
            headerOffset = 0.0;
        }
        if (self.offset_y >= headerOffset) {
            scrollView.contentOffset = CGPointMake(0, headerOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (int i = 0; i < self.childVCs.count; i++) {
                    HSFBaseTableVC *vc = self.childVCs[i];
                    vc.vcCanScroll = YES;
                }
            }
        }else{
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, headerOffset);
            }
        }
        self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
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
