//
//  SnsViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "SnsViewController.h"
#import "SnsCell.h"
#import "SinaWeibo.h"
#import "TCWBEngine.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

@implementation SnsViewController

@synthesize itemArray=_itemArray;

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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SnsList" ofType:@"plist"];
    _itemArray=[NSMutableArray arrayWithContentsOfFile:path];

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
    return _itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SnsCell";
    SnsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *dict=[_itemArray objectAtIndex:indexPath.row];
    cell.imageView.image=[UIImage imageNamed:[dict objectForKey:@"image"]];
    cell.textLabel.text=[dict objectForKey:@"name"];
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    [cell.contentView bringSubviewToFront:cell.switchBtn];
    cell.switchBtn.tag=indexPath.row;
    [cell.switchBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventValueChanged];
    if (indexPath.row==0) {
        SinaWeibo *sinaweibo = [self sinaweibo];
        BOOL authValid = sinaweibo.isAuthValid;
        cell.switchBtn.on=authValid;
    }
    if (indexPath.row==1) {
        TCWBEngine *txweibo=[self txweibo];
        cell.switchBtn.on=!txweibo.isAuthorizeExpired;
    }
    return cell;
}

- (IBAction)switchBtnClicked:(id)sender{
    NSInteger tag=[(UISwitch*)sender tag];
    BOOL isOn=[(UISwitch*)sender isOn];
    switch (tag) {
        case 0:
        {
            if (isOn) {
                SinaWeibo *sinaweibo = [self sinaweibo];
                [sinaweibo logIn];
            }else{
                SinaWeibo *sinaweibo = [self sinaweibo];
                [sinaweibo logOut];
            }
            break;
        } 
        default:
        {
            if (isOn) {
                TCWBEngine *txweibo = [self txweibo];
                [txweibo logInWithDelegate:self
                                     onSuccess:@selector(onSuccessLogin)
                                     onFailure:@selector(onFailureLogin:)];
            }else{
                TCWBEngine *txweibo = [self txweibo];
                [txweibo logOut];
                [self.tableView reloadData];
            }
            break;
        }
    }
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

#pragma mark - SinaWeibo delegate

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.sinaweibo.delegate=self;
    return delegate.sinaweibo;
    
}
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    [self.tableView reloadData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
    [self.tableView reloadData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
    [self.tableView reloadData];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{
    
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error{
    
}

#pragma mark - TengxunWeibo delegate

- (TCWBEngine*)txweibo{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.txweibo setRootViewController:self];
    return delegate.txweibo;
}

//登录成功回调
- (void)onSuccessLogin
{
    [self.tableView reloadData];
}

//登录失败回调
- (void)onFailureLogin:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"登录失败！"];
    [self.tableView reloadData];
}

@end
