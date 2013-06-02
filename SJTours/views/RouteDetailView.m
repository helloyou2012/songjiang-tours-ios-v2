//
//  RouteDetailView.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/14/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "RouteDetailView.h"
#import "RouteDetailCell.h"

@implementation RouteDetailView

@synthesize titleLabel=_titleLabel;
@synthesize tipLabel=_tipLabel;
@synthesize tableView=_tableView;
@synthesize headerBtn=_headerBtn;
@synthesize delegate=_delegate;
@synthesize tableDatas=_tableDatas;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _headerBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        _headerBtn.backgroundColor=[UIColor whiteColor];
        [_headerBtn addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 20)];
        _titleLabel.font=[UIFont systemFontOfSize:14.0f];
        _titleLabel.textColor=[UIColor blackColor];
        [_headerBtn addSubview:_titleLabel];
        
        _tipLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 20)];
        _tipLabel.font=[UIFont systemFontOfSize:14.0f];
        _tipLabel.textColor=[UIColor lightGrayColor];
        [_headerBtn addSubview:_tipLabel];
        
        [self addSubview:_headerBtn];
        
        UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 60.0f, 320, 6)];
        lineImage.image=[UIImage imageNamed:@"nav_bar_shadow"];
        [self addSubview:lineImage];
        
        _tableDatas=[[NSMutableArray alloc] init];
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, self.bounds.size.height-60.0f) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self addSubview:_tableView];
    }
    return self;
}

- (IBAction)headerClicked:(id)sender{
    [_delegate headerChanged];
}

- (void)showTransitRouteResult:(BMKTransitRoutePlan*)plan
{
    [_tableDatas removeAllObjects];
    int size = [plan.lines count];
    for (int i = 0; i < size; i++) {
        if (i==0) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            BMKRoute* route = [plan.routes objectAtIndex:i];
            [dict setObject:route.tip forKey:@"title"];
            [dict setObject:@"icon_foot" forKey:@"image"];
            [_tableDatas addObject:dict];
        }
        BMKLine* line = [plan.lines objectAtIndex:i];
        NSMutableDictionary *linedict=[[NSMutableDictionary alloc] init];
        [linedict setObject:line.tip forKey:@"title"];
        if (line.type == 0) {
            [linedict setObject:@"icon_bus" forKey:@"image"];
        } else {
            [linedict setObject:@"icon_subway" forKey:@"image"];
        }
        [_tableDatas addObject:linedict];
        
        BMKRoute* route = [plan.routes objectAtIndex:i+1];
        NSMutableDictionary *routedict=[[NSMutableDictionary alloc] init];
        [routedict setObject:route.tip forKey:@"title"];
        [routedict setObject:@"icon_foot" forKey:@"image"];
        [_tableDatas addObject:routedict];
    }
    [_tableView reloadData];
}


- (void)showDrivingRouteResult:(BMKRoutePlan*)plan
{
    [_tableDatas removeAllObjects];
    NSMutableDictionary *dict1=[[NSMutableDictionary alloc] init];
    [dict1 setObject:@"从这里出发" forKey:@"title"];
    [dict1 setObject:@"icon_car" forKey:@"image"];
    [_tableDatas addObject:dict1];
    
    for (int i = 0; i < 1; i++) {
        BMKRoute* route = [plan.routes objectAtIndex:i];
        int size = route.steps.count;
        for (int j = 0; j < size; j++) {
            BMKStep* step = [route.steps objectAtIndex:j];
            NSMutableDictionary *dict2=[[NSMutableDictionary alloc] init];
            [dict2 setObject:step.content forKey:@"title"];
            [dict2 setObject:@"icon_car" forKey:@"image"];
            [_tableDatas addObject:dict2];
        }
        
    }
    NSMutableDictionary *dict3=[[NSMutableDictionary alloc] init];
    [dict3 setObject:@"到达终点" forKey:@"title"];
    [dict3 setObject:@"icon_car" forKey:@"image"];
    [_tableDatas addObject:dict3];
    [_tableView reloadData];
	
}

- (void)showWalkingRouteResult:(BMKRoutePlan*)plan
{
    [_tableDatas removeAllObjects];
    NSMutableDictionary *dict1=[[NSMutableDictionary alloc] init];
    [dict1 setObject:@"从这里出发" forKey:@"title"];
    [dict1 setObject:@"icon_foot" forKey:@"image"];
    [_tableDatas addObject:dict1];
    
    for (int i = 0; i < 1; i++) {
        BMKRoute* route = [plan.routes objectAtIndex:i];
        int size = route.steps.count;
        for (int j = 0; j < size; j++) {
            BMKStep* step = [route.steps objectAtIndex:j];
            NSMutableDictionary *dict2=[[NSMutableDictionary alloc] init];
            [dict2 setObject:step.content forKey:@"title"];
            [dict2 setObject:@"icon_foot" forKey:@"image"];
            [_tableDatas addObject:dict2];
        }
    }
    NSMutableDictionary *dict3=[[NSMutableDictionary alloc] init];
    [dict3 setObject:@"到达终点" forKey:@"title"];
    [dict3 setObject:@"icon_foot" forKey:@"image"];
    [_tableDatas addObject:dict3];
    [_tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WaysCell";
    
    RouteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RouteDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict=[_tableDatas objectAtIndex:indexPath.row];
    cell.imageWay.image=[UIImage imageNamed:[dict objectForKey:@"image"]];
    cell.titleWay.frame=CGRectMake(40, 0, 270, 10);
    cell.titleWay.text=[dict objectForKey:@"title"];
    [cell.titleWay sizeToFit];
    CGRect rect=cell.titleWay.frame;
    rect.origin.y=(50.0f-rect.size.height)/2;
    cell.titleWay.frame=rect;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate headerChanged];
    [_delegate cellSelectedAt:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

@end
