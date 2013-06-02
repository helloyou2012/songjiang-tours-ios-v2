//
//  JiaotongDetailViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/27/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "JiaotongDetailViewController.h"
#import "JiaotongDetailCell.h"

@implementation JiaotongDetailViewController

@synthesize curData=_curData;
@synthesize routeLines=_routeLines;
@synthesize headerView=_headerView;

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
    
    //self.view.backgroundColor=[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    UIImage *image = [UIImage imageNamed:@"background_header"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    if (_curData) {
        NSString *contents=[_curData objectForKey:@"tfcontent"];
        _routeLines =[NSMutableArray arrayWithArray:[contents componentsSeparatedByString:@"-"]];
        [_headerView createViewData:_curData];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return _routeLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JiaotongDetailCell";
    JiaotongDetailCell *cell = [[JiaotongDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (indexPath.row==0) {
        cell.linetype=0;
    }else if(indexPath.row==_routeLines.count-1){
        cell.linetype=2;
    }else{
        cell.linetype=1;
    }
    [cell createViews:[_routeLines objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)gotoBusMapClicked:(id)sender{
    [self performSegueWithIdentifier:@"gotoBusMap" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setValue:[_curData objectForKey:@"tfline"] forKey:@"busName"];
}

@end
