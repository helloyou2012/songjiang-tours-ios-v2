//
//  ImageTableViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/8/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "ImageTableViewController.h"
#import "PhotosCell.h"
#import "UIButton+WebCache.h"
#import "RequestUrls.h"

@implementation ImageTableViewController

@synthesize imageArray=_imageArray;

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
    
    
    UIColor *background=[UIColor colorWithRed:0.949f green:0.949f blue:0.949f alpha:1.0f];
    self.tableView.backgroundColor = background;

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
    return ceil(1.0*_imageArray.count/[PhotosCell numberOfPlaceHolders]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotosCell";
    
    PhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PhotosCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger numberOfPlaceholders = [PhotosCell numberOfPlaceHolders];
    NSUInteger rowIndex = [indexPath row];
    NSInteger realIndex = rowIndex *numberOfPlaceholders;
    NSInteger numberOfAll=_imageArray.count;
    for (NSInteger i = 0; i < numberOfPlaceholders &&
         (realIndex + i) < numberOfAll; ++i)
    {
        NSDictionary *imageDict=[_imageArray objectAtIndex:realIndex+i];
        NSString *url=[NSString stringWithFormat:@"%@%@",[RequestUrls domainUrl],[imageDict objectForKey:@"imageUrl"]];
        NSURL *imageUrl=[[NSURL alloc] initWithString:url];
        
        UIButton *imageButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 96, 96)];
        [imageButton setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
        imageButton.tag=realIndex+i;
        [imageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addViewModeView:imageButton atIndex:i];
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

- (IBAction)imageButtonClicked:(id)sender{
    NSInteger tag=[(UIButton*)sender tag];
    // Create browser
	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.wantsFullScreenLayout = NO;
    [browser setInitialPageIndex:tag];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:nc animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imageArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSDictionary *imageDict=[_imageArray objectAtIndex:index];
    NSString *url=[NSString stringWithFormat:@"%@%@",[RequestUrls domainUrl],[imageDict objectForKey:@"imageUrl"]];
    NSURL *imageUrl=[[NSURL alloc] initWithString:url];
    MWPhoto *photo=[MWPhoto photoWithURL:imageUrl];
    return photo;
}

@end
