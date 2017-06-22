//
//  ViewController.m
//  HSFDemo
//
//  Created by JuZhenBaoiMac on 2017/6/22.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "ViewController.h"

#import "HSFTableView.h"
#import "HSFTableCell.h"
#define k_Header_Height 200
#import "MLMSegmentManager.h"
#import "VC1.h"
#import "VC2.h"
#import "VC3.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet HSFTableView *tableView;
@property (nonatomic,strong) UIView *header;
@property (nonatomic,strong) UIImageView *headerImgView;
@property (nonatomic,strong) HSFTableCell *cell;

@property (nonatomic,assign) CGFloat offset_y;


@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@property (nonatomic,strong) VC1 *vc_1;
@property (nonatomic,strong) VC2 *vc_2;
@property (nonatomic,strong) VC3 *vc_3;

@property (nonatomic,assign) BOOL canScroll;//默认刚开始是YES

@end


@implementation ViewController
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
    self.canScroll = YES;//默认刚开始是YES
    //配置tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.header;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFTableCell class])];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVCScrollState:) name:@"changeVCScrollState" object:nil];
}
-(void)changeVCScrollState:(NSNotification *)sender{
    self.canScroll = YES;
    self.vc_1.vcCanScroll = NO;
    self.vc_2.vcCanScroll = NO;
    self.vc_3.vcCanScroll = NO;
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
    NSArray *list = @[@"商品",
                      @"商家信息",
                      @"评价"];
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
    self.vc_1 = [[VC1 alloc]init];
    self.vc_2 = [[VC2 alloc]init];
    self.vc_3 = [[VC3 alloc]init];
    
    [arr addObject:self.vc_1];
    [arr addObject:self.vc_2];
    [arr addObject:self.vc_3];
    
    return arr;
}

#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        self.offset_y = scrollView.contentOffset.y;
        NSLog(@"offset_y = %f",self.offset_y);
        //下拉放大header
        CGFloat deta = ABS(self.offset_y);
        if (self.offset_y <= 0) {
            self.headerImgView.frame = CGRectMake(0, -deta, self.view.frame.size.width, k_Header_Height + deta);
        }
        
        /* 关键 */
        if (self.offset_y >= k_Header_Height) {
            scrollView.contentOffset = CGPointMake(0, k_Header_Height);
            if (self.canScroll) {
                self.canScroll = NO;
                self.vc_1.vcCanScroll = YES;
                self.vc_2.vcCanScroll = YES;
                self.vc_3.vcCanScroll = YES;
            }
        }else{
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, k_Header_Height);
            }
        }
        self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
