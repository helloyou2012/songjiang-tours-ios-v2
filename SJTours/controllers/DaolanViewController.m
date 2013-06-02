//
//  DaolanViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/18/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "DaolanViewController.h"

@implementation DaolanViewController

@synthesize menuItems=_menuItems;
@synthesize currentDict=_currentDict;

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
    self.tableView.backgroundColor=[UIColor colorWithRed:245.0f/255.0f green:240.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MenuItems" ofType:@"plist"];
    _menuItems=[NSMutableArray arrayWithContentsOfFile:path];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [self createRightBarButtonItem];
}

- (UIBarButtonItem*)createRightBarButtonItem{
    UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(5, 5, 34, 34)];
    UIButton *rightFavorBtn=[[UIButton alloc] initWithFrame:CGRectMake(5, 5, 24, 24)];
    [rightFavorBtn setImage:[UIImage imageNamed:@"toolmap_favor"] forState:UIControlStateNormal];
    [rightFavorBtn addTarget:self action:@selector(favorClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightFavorBtn showsTouchWhenHighlighted];
    [barView addSubview:rightFavorBtn];
    barView.clipsToBounds=YES;
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc] initWithCustomView:barView];
    return buttonItem;
}

- (void)favorClicked{
    [self performSegueWithIdentifier:@"gotoShoucang" sender:self];
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
    return ceil(_menuItems.count/3.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuGroupCell";
    
    MenuGroupCell *cell = [[MenuGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSInteger numberOfLine = [MenuGroupCell numberOfPlaceHolders];
    
    NSUInteger rowIndex = [indexPath row];
    NSInteger thumbnailIndex = rowIndex *numberOfLine;
    NSInteger numberOfGroups = _menuItems.count;
    for (NSInteger i = 0; i < numberOfLine; ++i)
    {
        if ((thumbnailIndex + i) < numberOfGroups) {
            NSDictionary *numberItem = [_menuItems objectAtIndex:thumbnailIndex+i];
            MenuGroupView *groupView=[[MenuGroupView alloc] initWithObject:numberItem isSearch:NO];
            groupView.delegate=self;
            [cell addGroupView:groupView atIndex:i];
        }else{
            UIView *nullView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 80.0f, 106.0f)];
            UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"menu_bg"]];
            nullView.backgroundColor = background;
            [cell addGroupView:nullView atIndex:i];
        }
        
    }
    UIView *line2View=[[UIView alloc] initWithFrame:CGRectMake(0, 105, 320.0f, 2.0f)];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"base_line"]];
    line2View.backgroundColor = background;
    [cell addSubview:line2View];
    if (indexPath.row==0) {
        UIView *line1View=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 2.0f)];
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"base_line"]];
        line1View.backgroundColor = background;
        [cell addSubview:line1View];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *footerView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 40)];
    footerView.image=[UIImage imageNamed:@"feed-end"];
    footerView.contentMode=UIViewContentModeCenter|UIViewContentModeBottom;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40.0f;
}

- (void)groupClicked:(NSDictionary*)dict{
    _currentDict=dict;
    if ([[dict objectForKey:@"pushIdentifier"] isEqual:@"gotoViewSpots"]) {
        [self performSegueWithIdentifier:[dict objectForKey:@"pushIdentifier"] sender:self];
    }
    if ([[dict objectForKey:@"pushIdentifier"] isEqual:@"gotoJiaotong"]) {
        [self performSegueWithIdentifier:[dict objectForKey:@"pushIdentifier"] sender:self];
    }
    if ([[dict objectForKey:@"pushIdentifier"] isEqual:@"gotoGonglue"]) {
        [self performSegueWithIdentifier:[dict objectForKey:@"pushIdentifier"] sender:self];
    }
    if ([[dict objectForKey:@"pushIdentifier"] isEqual:@"gotoTianqi"]) {
        [self performSegueWithIdentifier:[dict objectForKey:@"pushIdentifier"] sender:self];
    }
    if ([[dict objectForKey:@"pushIdentifier"] isEqual:@"gotoChengshi"]) {
        [self performSegueWithIdentifier:[dict objectForKey:@"pushIdentifier"] sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![segue.identifier isEqual:@"gotoShoucang"]) {
        [segue.destinationViewController setValue:_currentDict forKey:@"dictType"];
    }
}

@end
