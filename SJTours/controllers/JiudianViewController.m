//
//  JiudianViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 7/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "JiudianViewController.h"
#import "JingdianCell.h"
#import "SVProgressHUD.h"
#import "RequestUrls.h"
#import "ViewSpotsModelManager.h"

#define PAGE_COUNT 10

@implementation JiudianViewController

@synthesize curPage=_curPage;
@synthesize reloading=_reloading;
@synthesize isEnding=_isEnding;
@synthesize refreshHeaderView=_refreshHeaderView;
@synthesize jingdianRequest=_jingdianRequest;
@synthesize selectedIndex=_selectedIndex;
@synthesize dictType=_dictType;
@synthesize modelManager=_modelManager;
@synthesize segmentedControl=_segmentedControl;

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
    self.title=[_dictType objectForKey:@"name"];
    
    UIColor *background=[UIColor colorWithRed:0.949f green:0.949f blue:0.949f alpha:1.0f];
    self.tableView.backgroundColor = background;
    self.tableView.separatorColor=[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.0f];
    
    _modelManager=[[ViewSpotsModelManager alloc] initWith:[_dictType objectForKey:@"filename"]];
    [self.tableView reloadData];
    
    _curPage = 1;
    _isEnding=NO;
    _jingdianRequest=[[JingdianRequest alloc] init];
    _jingdianRequest.delegate=self;
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
    [_jingdianRequest.connection cancel];
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
    if (_isEnding) {
        return [_modelManager.mainArray count];
    } else {
        return [_modelManager.mainArray count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
    
    if (indexPath.row == [_modelManager.mainArray count]&&!_isEnding) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Load more cell"];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"加载更多...";
        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor=[UIColor grayColor];
        cell.textLabel.highlightedTextColor=[UIColor grayColor];
        [cell setSelectedBackgroundView:bgColorView];
        return cell;
    }else{
        static NSString *CellIdentifier = @"JingdianCell";
        
        JingdianCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[JingdianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        NSMutableDictionary *data=[_modelManager.mainArray objectAtIndex:indexPath.row];
        [cell createView:data];
        [cell setSelectedBackgroundView:bgColorView];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_modelManager.mainArray count]) {
        _selectedIndex=indexPath.row;
        [self performSegueWithIdentifier:@"gotoDetail" sender:self];
    } else {
        [self loadMoreData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setValue:[_modelManager.mainArray objectAtIndex:_selectedIndex] forKey:@"curData"];
}

- (void)setupEGORefresh
{
    if (_refreshHeaderView == nil) {
        CGFloat tableHeight=self.tableView.bounds.size.height;
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, - tableHeight, self.tableView.frame.size.width, tableHeight)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)loadMoreData
{
    NSString *type_str=@"2";
    switch (_segmentedControl.selectedSegmentIndex)
    {
        case 1:
            type_str=@"21";
            break;
        case 2:
            type_str=@"22";
            break;
        case 3:
            type_str=@"23";
            break;
        case 4:
            type_str=@"24";
            break;
    }
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    [data setObject:[NSString stringWithFormat:@"%d",_curPage] forKey:@"page"];
    [data setObject:[NSString stringWithFormat:@"%d",PAGE_COUNT] forKey:@"rows"];
    [data setObject:type_str forKey:@"type"];
    _jingdianRequest.requestUrl=[RequestUrls viewportList];
    _jingdianRequest.requestData=data;
    [_jingdianRequest createConnection];
}

-(void) jingdianRequestFinished:(NSArray*)data withError:(NSString*)error
{
    _reloading = NO;
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }else{
        if (_curPage<=1) {
            [_modelManager.mainArray removeAllObjects];
        }
        if (data) {
            if (data.count<PAGE_COUNT) {
                _isEnding=YES;
            }
            [_modelManager.mainArray addObjectsFromArray:data];
        }else{
            _isEnding=YES;
        }
        
        if (_curPage==1&&[_modelManager.mainArray count]==0) {
            [SVProgressHUD showErrorWithStatus:@"暂时没有数据"];
        }else{
            _curPage++;
            [_modelManager saveData];
            [self.tableView reloadData];
        }
    }
}

- (IBAction)segmentDidChange:(id)sender
{
    if (_jingdianRequest&&_jingdianRequest.connection) {
        [_jingdianRequest.connection cancel];
        _reloading=NO;
    }
    [self reloadTableViewDataSource];
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
