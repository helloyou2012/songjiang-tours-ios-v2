//
//  YinxiangViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/15/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "YinxiangViewController.h"
#import "YinxiangCell.h"
#import "RequestUrls.h"
#import "SVProgressHUD.h"

@implementation YinxiangViewController

@synthesize selectedIndex=_selectedIndex;
@synthesize request=_request;
@synthesize refreshHeaderView=_refreshHeaderView;
@synthesize reloading=_reloading;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [self setupEGORefresh];
    
    _request=[[YinXiangRequest alloc] initWithUrl:[RequestUrls galleryUrl]];
    _request.delegate=self;
    [_request createConnection];
    _reloading=YES;
    _selectedIndex=0;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [_request.connection cancel];
    _reloading=NO;
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
    YinXiangModelManager *manager=[YinXiangModelManager sharedInstance];
    return manager.mainArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"YinxiangCell";
    YinxiangCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YinxiangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    YinXiangModelManager *manager=[YinXiangModelManager sharedInstance];
    NSDictionary *dict=[manager.mainArray objectAtIndex:indexPath.row];
    NSDictionary *gallery=[dict objectForKey:@"gallery"];
    [cell createViews:gallery];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 211.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex=indexPath.row;
    // Create browser
	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    //browser.wantsFullScreenLayout = NO;
    //[browser setInitialPageIndex:2];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:nc animated:YES];
}

-(void) yinXiangRequestFinished:(NSMutableArray*)data withError:(NSString*)error{
    _reloading=NO;
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }else{
        if (data&&data.count>0) {
            YinXiangModelManager *manager=[YinXiangModelManager sharedInstance];
            [manager.mainArray removeAllObjects];
            [manager.mainArray addObjectsFromArray:data];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    YinXiangModelManager *manager=[YinXiangModelManager sharedInstance];
    NSMutableDictionary *itemDict=[manager.mainArray objectAtIndex:_selectedIndex];
    NSMutableArray *images=[itemDict objectForKey:@"items"];
    return images.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    YinXiangModelManager *manager=[YinXiangModelManager sharedInstance];
    NSMutableDictionary *itemDict=[manager.mainArray objectAtIndex:_selectedIndex];
    NSMutableArray *images=[itemDict objectForKey:@"items"];
    NSDictionary *imageDict=[images objectAtIndex:index];
    if (index < images.count){
        NSString *imageUrl=[NSString stringWithFormat:@"%@%@",[RequestUrls domainUrl],[imageDict objectForKey:@"giimage"]];
        MWPhoto *photo=[MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]];
        photo.caption=[imageDict objectForKey:@"giinfo"];
        return photo;
    }
    return nil;
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
    [_request createConnection];
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
