//
//  DetailsViewController.m
//  NeverStop
//
//  Created by DYQ on 16/11/14.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DetailsViewController.h"
#import "PlanDetailsModel.h"
#import "EverydayDetailModel.h"

@interface DetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) NSArray *planDetailsArr;
@property (nonatomic, strong) PlanDetailsModel *planDetailsModel;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *typeImageView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getData];
    [self createTableView];
}

- (void)createTableView {
    self.detailTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.contentInset = UIEdgeInsetsMake(200, 0, 64, 0);
    [self.view addSubview:_detailTableView];
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, SCREEN_WIDTH, 200)];
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:_planDetailsModel.planBg] placeholderImage:nil];
    [_detailTableView addSubview:_backImageView];
    
    self.typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 70, 90, 90)];
    [_typeImageView sd_setImageWithURL:[NSURL URLWithString:_planDetailsModel.planImg] placeholderImage:nil];
    [_backImageView addSubview:_typeImageView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _planDetailsModel.plandetails.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (void)getData {
    [HttpClient GET:[NSString stringWithFormat:@"http://training.api.thejoyrun.com/getPlanDetails?planId=%@&signature=A95591D685A7ED41C9C818EF1283DA39&timestamp=1478944560", _planId] body:nil headerFile:nil response:JYX_JSON success:^(id result) {
        NSDictionary *dataDic = [result objectForKey:@"data"];
        self.planDetailsModel = [PlanDetailsModel mj_objectWithKeyValues:dataDic];
        DDLogInfo(@"%@", _planDetailsModel);
    } failure:^(NSError *error) {
        
        DDLogInfo(@"error : %@", error);
    }];
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
