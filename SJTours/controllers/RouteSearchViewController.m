//
//  RouteSearchViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/11/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "RouteSearchViewController.h"
#import "PrettyKit.h"
#import "RouteSearchCell.h"
#import "SVProgressHUD.h"
#import "RouteMapViewController.h"

@implementation RouteSearchViewController

@synthesize headerSearchView=_headerSearchView;
@synthesize headerWaysView=_headerWaysView;
@synthesize tableView=_tableView;
@synthesize curData=_curData;
@synthesize search=_search;
@synthesize resultArray=_resultArray;
@synthesize resultMap=_resultMap;
@synthesize selectedIndex=_selectedIndex;
@synthesize keyControlBtn=_keyControlBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _headerSearchView=[[RouteSearchView alloc] initWithFrame:CGRectMake(0, 0, 320, 95)];
    [_headerSearchView createViews];
    [self.view addSubview:_headerSearchView];
    _headerSearchView.fromTextField.text=@"我的位置";
    _headerSearchView.toTextField.text=[_curData objectForKey:@"vtitle"];
    _headerSearchView.baseAddress=[_curData objectForKey:@"vtitle"];
    _headerSearchView.baseLat=[[_curData objectForKey:@"lat"] doubleValue];
    _headerSearchView.baseLng=[[_curData objectForKey:@"lng"] doubleValue];
    _headerSearchView.delegate=self;
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    UIColor *background=[UIColor colorWithRed:0.949f green:0.949f blue:0.949f alpha:1.0f];
    self.view.backgroundColor = background;
    _tableView.separatorColor=[UIColor clearColor];
    
    [_headerWaysView createViews];
    _headerWaysView.delegate=self;
    
    [self customizeNavBar];
    
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelClicked:)];
    cancelItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.leftBarButtonItem=cancelItem;
    
    UIBarButtonItem *searchItem=[[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleBordered target:self action:@selector(searchClicked:)];
    searchItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem=searchItem;
    
    _search=[[BMKSearch alloc] init];
    _search.delegate=self;
    
    _resultArray=[[NSMutableArray alloc] init];
    [self searchNow];
    
    _keyControlBtn=[[UIButton alloc] initWithFrame:CGRectMake(274, self.view.bounds.size.height-72.0f, 38.0f, 30.0f)];
    [_keyControlBtn setImage:[UIImage imageNamed:@"show_keyboard_btn"] forState:UIControlStateNormal];
    [_keyControlBtn setImage:[UIImage imageNamed:@"hide_keyboard_btn"] forState:UIControlStateSelected];
    [_keyControlBtn addTarget:self action:@selector(keyControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_keyControlBtn];
    [self registerForKeyboardNotifications];
	// Do any additional setup after loading the view.
}

- (IBAction)cancelClicked:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)searchClicked:(id)sender{
    [self searchNow];
}

- (IBAction)keyControlClicked:(id)sender{
    BOOL isSelected=[(UIButton*)sender isSelected];
    if (isSelected) {
        [_headerSearchView.fromTextField resignFirstResponder];
        [_headerSearchView.toTextField resignFirstResponder];
    }else{
        [_headerSearchView.toTextField becomeFirstResponder];
    }
}

- (void)customizeNavBar
{
    PrettyNavigationBar *navBar = (PrettyNavigationBar *) self.navigationController.navigationBar;
    
    navBar.topLineColor = [UIColor colorWithHex:0xf5f5f5];
    navBar.gradientStartColor = [UIColor colorWithHex:0xf5f5f5];
    navBar.gradientEndColor = [UIColor colorWithHex:0xededed];
    navBar.bottomLineColor = [UIColor colorWithHex:0xededed];
    navBar.tintColor = [UIColor colorWithHex:0xededed];
    navBar.roundedCornerRadius = 4;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RouteSearchCell";
    RouteSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RouteSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell createViews:[_resultArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex=indexPath.row;
    [self performSegueWithIdentifier:@"gotoMapDetail" sender:self];
}

#pragma mark - Search Delegate
- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error{
    if (error == BMKErrorOk) {
        [_resultArray removeAllObjects];
        _resultMap=result;
        for (NSInteger i=0; i<result.plans.count; i++) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[result.plans objectAtIndex:i];
            NSString *lineName=@"";
            int size = [plan.lines count];
            for (int i = 0; i < size; i++) {
                BMKLine* line = [plan.lines objectAtIndex:i];
                if (i==0) {
                    lineName=[lineName stringByAppendingString:[self getTransitShortName:line.title]];
                } else {
                    lineName=[lineName stringByAppendingFormat:@"→%@",[self getTransitShortName:line.title]];
                }
            }
            NSString *dist=[NSString stringWithFormat:@"%.2f公里",plan.distance/1000.0f];
            [dict setObject:lineName forKey:@"title"];
            [dict setObject:dist forKey:@"tip"];
            [_resultArray addObject:dict];
        }
        [_tableView reloadData];
	}
}

- (NSString*)getTransitShortName:(NSString*)longName{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\(.*\\)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:longName options:0 range:NSMakeRange(0, [longName length]) withTemplate:@""];
    return modifiedString;
}

- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error{
    if (error == BMKErrorOk) {
        [_resultArray removeAllObjects];
        _resultMap=result;
        for (NSInteger i=0; i<result.plans.count; i++) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:i];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            NSString *dist=[NSString stringWithFormat:@"%.2f公里",plan.distance/1000.0f];
            NSString *lineName=[NSString stringWithFormat:@"驾车方案 %d",i+1];
            [dict setObject:lineName forKey:@"title"];
            [dict setObject:dist forKey:@"tip"];
            [_resultArray addObject:dict];
        }
        [_tableView reloadData];
	}
}

- (void)onGetWalkingRouteResult:(BMKPlanResult*)result errorCode:(int)error{
    if (error == BMKErrorOk) {
        [_resultArray removeAllObjects];
        _resultMap=result;
        for (NSInteger i=0; i<result.plans.count; i++) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:i];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            NSString *dist=[NSString stringWithFormat:@"%.2f公里",plan.distance/1000.0f];
            NSString *lineName=[NSString stringWithFormat:@"步行方案 %d",i+1];
            [dict setObject:lineName forKey:@"title"];
            [dict setObject:dist forKey:@"tip"];
            [_resultArray addObject:dict];
        }
        [_tableView reloadData];
	}
}

- (void)searchNow{
    BMKPlanNode* start = [_headerSearchView getStartedNode];
    BMKPlanNode* end = [_headerSearchView getEndedNode];
    if (start!=nil&&end!=nil) {
        BOOL flag=NO;
        if ([_headerWaysView selected]==1) {
            flag = [_search transitSearch:@"上海市" startNode:start endNode:end];
        }
        if ([_headerWaysView selected]==2) {
            flag = [_search drivingSearch:@"上海市" startNode:start endCity:@"上海市" endNode:end];
        }
        if ([_headerWaysView selected]==3) {
            flag = [_search walkingSearch:@"上海市" startNode:start endCity:@"上海市" endNode:end];
        }
        
        if (!flag) {
            [SVProgressHUD showErrorWithStatus:@"搜索路径失败！"];
        }
        
    }
}

- (void)searchTypeChanged{
    [self searchNow];
}

- (void)searchPlaceChanged{
    [self searchNow];
}

#pragma mark Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardWillShowNotification is sent.
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect rect=_keyControlBtn.frame;
    rect.origin.y=self.view.bounds.size.height-kbSize.height-28.0f;
    [UIView animateWithDuration:0.3 animations:^{
        _keyControlBtn.frame=rect;
        _keyControlBtn.selected=YES;
    }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect rect=_keyControlBtn.frame;
    rect.origin.y=self.view.bounds.size.height-28.0f;
    [UIView animateWithDuration:0.3 animations:^{
        _keyControlBtn.frame=rect;
        _keyControlBtn.selected=NO;
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RouteMapViewController *vc=(RouteMapViewController*)segue.destinationViewController;
    vc.resultMap=_resultMap;
    vc.resultArray=_resultArray;
    vc.currentPage=_selectedIndex;
    vc.mapType=_headerWaysView.selected;
    
}

@end
