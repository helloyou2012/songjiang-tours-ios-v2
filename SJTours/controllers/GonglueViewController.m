//
//  GonglueViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/18/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "GonglueViewController.h"
#import "GonglueCell.h"
#import "SVProgressHUD.h"
#import "RequestUrls.h"
#import "GonglueModelManager.h"

#define PAGE_COUNT 10

@implementation GonglueViewController

@synthesize curPage=_curPage;
@synthesize reloading=_reloading;
@synthesize isEnding=_isEnding;
@synthesize refreshHeaderView=_refreshHeaderView;
@synthesize gonglueRequest=_gonglueRequest;
@synthesize selectedIndex=_selectedIndex;
@synthesize dictType=_dictType;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"weibo_bg"]];
    //    self.tableView.backgroundColor = background;
    //    self.tableView.separatorColor=[UIColor colorWithRed:0.901961f green:0.901961f blue:0.901961f alpha:1.0f];
    
    UIColor *background=[UIColor colorWithRed:0.949f green:0.949f blue:0.949f alpha:1.0f];
    self.tableView.backgroundColor = background;
    self.tableView.separatorColor=[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.0f];
    
    _curPage = 1;
    _isEnding=NO;
    _gonglueRequest=[[GonglueRequest alloc] init];
    _gonglueRequest.delegate=self;
    [self setupEGORefresh];
    [self reloadTableViewDataSource];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    [_gonglueRequest.connection cancel];
    _reloading=NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GonglueModelManager *manager=[GonglueModelManager sharedInstance];
    if (_isEnding) {
        return [manager.mainArray count];
    } else {
        return [manager.mainArray count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GonglueModelManager *manager=[GonglueModelManager sharedInstance];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
    
    if (indexPath.row == [manager.mainArray count]&&!_isEnding) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Load more cell"];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"加载更多...";
        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor=[UIColor grayColor];
        cell.textLabel.highlightedTextColor=[UIColor grayColor];
        [cell setSelectedBackgroundView:bgColorView];
        return cell;
    }else{
        static NSString *CellIdentifier = @"GonglueCell";
        
        GonglueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[GonglueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        NSMutableDictionary *data=[manager.mainArray objectAtIndex:indexPath.row];
        [cell createView:data];
        [cell setSelectedBackgroundView:bgColorView];
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GonglueModelManager *manager=[GonglueModelManager sharedInstance];
    if (indexPath.row < [manager.mainArray count]) {
        _selectedIndex=indexPath.row;
        [self performSegueWithIdentifier:@"gotoDetail" sender:self];
    } else {
        [self loadMoreData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GonglueModelManager *manager=[GonglueModelManager sharedInstance];
    [segue.destinationViewController setValue:[manager.mainArray objectAtIndex:_selectedIndex] forKey:@"curData"];
}

- (void)setupEGORefresh
{
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.frame.size.width, self.view.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)loadMoreData
{
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    [data setObject:[NSString stringWithFormat:@"%d",_curPage] forKey:@"page"];
    [data setObject:[NSString stringWithFormat:@"%d",PAGE_COUNT] forKey:@"rows"];
    _gonglueRequest.requestUrl=[RequestUrls strategyList];
    _gonglueRequest.requestData=data;
    [_gonglueRequest createConnection];
}

-(void) gonglueRequestFinished:(NSArray*)data withError:(NSString*)error
{
    _reloading = NO;
    GonglueModelManager *manager=[GonglueModelManager sharedInstance];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }else{
        if (_curPage<=1) {
            [manager.mainArray removeAllObjects];
        }
        if (data) {
            if (data.count<PAGE_COUNT) {
                _isEnding=YES;
            }
            [manager.mainArray addObjectsFromArray:data];
        }else{
            _isEnding=YES;
        }
        
        if (_curPage==1&&[manager.mainArray count]==0) {
            [SVProgressHUD showErrorWithStatus:@"暂时没有数据"];
        }else{
            _curPage++;
            [manager saveData];
            [self.tableView reloadData];
        }
    }
}

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    _reloading = YES;
    _curPage = 1;
    _isEnding=NO;
    [self loadMoreData];
    [self doneLoadingTableViewData];
}

- (void)doneLoadingTableViewData{
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

@end
