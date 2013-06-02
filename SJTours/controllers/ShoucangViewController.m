//
//  ShoucangViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/21/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "ShoucangViewController.h"
#import "Viewport.h"
#import "AppDelegate.h"
#import "JingdianCell.h"

@implementation ShoucangViewController

@synthesize searchResults=_searchResults;
@synthesize isSearching=_isSearching;
@synthesize searchRequestNumber=_searchRequestNumber;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize dictType=_dictType;
@synthesize curData=_curData;

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
    UIColor *background=[UIColor colorWithRed:246.0f/255.0f green:243.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
    self.tableView.backgroundColor = background;
    self.tableView.separatorColor=[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.0f];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
#pragma mark - Search Controller

- (void)updateSearchForController:(UISearchDisplayController *)controller {
    
    NSString *searchString = controller.searchBar.text;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *fgContext = [delegate managedObjectContext];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Viewport"
                inManagedObjectContext:fgContext];
    NSSortDescriptor *dateSort =
    [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"vtitle contains[cd] %@",
                              searchString];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSManagedObjectIDResultType];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:
     [NSArray arrayWithObjects:dateSort, nil]];
    
    if (!_isSearching) {
        _isSearching = TRUE;
        [controller.searchResultsTableView reloadData];
    }
    
    NSMutableSet *inserted = [NSMutableSet set];
    NSMutableSet *updated = [NSMutableSet set];
    NSMutableSet *deleted = [NSMutableSet set];
    
    NSSet *(^toObjectIDs)(NSSet *objects) = ^NSSet *(NSSet *objects) {
        NSMutableSet *result = [NSMutableSet set];
        for (NSManagedObject *object in objects) {
            [result addObject:[object objectID]];
        }
        return result;
    };
    
    [inserted unionSet:toObjectIDs([fgContext insertedObjects])];
    [updated unionSet:toObjectIDs([fgContext updatedObjects])];
    [deleted unionSet:toObjectIDs([fgContext deletedObjects])];
    
    void (^observationBlock)(NSNotification *) = ^(NSNotification *note) {
        NSDictionary *userInfo = [note userInfo];
        [inserted unionSet:toObjectIDs([userInfo objectForKey:NSInsertedObjectsKey])];
        [updated unionSet:toObjectIDs([userInfo objectForKey:NSUpdatedObjectsKey])];
        [deleted unionSet:toObjectIDs([userInfo objectForKey:NSDeletedObjectsKey])];
    };
    NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
    NSString *observe = NSManagedObjectContextObjectsDidChangeNotification;
    id observer = [noteCenter addObserverForName:observe
                                          object:fgContext
                                           queue:nil
                                      usingBlock:observationBlock];
    
    NSUInteger currentSearchRequest = ++_searchRequestNumber;
    NSManagedObjectContext *bkgdContext =
    [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [bkgdContext setPersistentStoreCoordinator:fgContext.persistentStoreCoordinator];
    [bkgdContext performBlock:^{
        NSLog(@"searching in background");
        NSArray *results = [bkgdContext executeFetchRequest:fetchRequest error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (currentSearchRequest == _searchRequestNumber) {
                NSMutableArray *objects = [NSMutableArray array];
                // there's no good way to add objects that were created mid-search to our
                // result without making the main thread hang, so we'll just put them at
                // the front of the list.
                for (NSManagedObjectID *objectID in inserted) {
                    NSManagedObject *object = [fgContext objectWithID:objectID];
                    if ([[object entity] isKindOfEntity:[fetchRequest entity]] &&
                        [predicate evaluateWithObject:object]) {
                        [objects addObject:object];
                    }
                }
                for (NSManagedObjectID *objectID in updated) {
                    NSManagedObject *object = [fgContext objectWithID:objectID];
                    if ([[object entity] isKindOfEntity:[fetchRequest entity]] &&
                        [predicate evaluateWithObject:object]) {
                        [objects addObject:object];
                    }
                }
                // go through the actual results
                for (NSManagedObjectID *objectID in results) {
                    NSManagedObject *object = [fgContext objectWithID:objectID];
                    if (![deleted containsObject:objectID] && // don't add deleted objects
                        ![updated containsObject:objectID]) { // updated added previously
                        [objects addObject:object];
                    }
                }
                _searchResults = objects;
                _isSearching = FALSE;
                [controller.searchResultsTableView reloadData];
                
                [noteCenter removeObserver:observer];
            }
        });
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self updateSearchForController:controller];
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    [self updateSearchForController:controller];
    return NO;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _isSearching ? 1 : [_searchResults count];
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.searchDisplayController.searchResultsTableView && _isSearching) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchingCell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"SearchingCell"];
        cell.textLabel.text = NSLocalizedString(@"Searching", nil);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
    
    JingdianCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"JingdianCell"];
    if (!cell) {
        cell = [[JingdianCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"JingdianCell"];
    }
    [self configureCell:cell atIndexPath:indexPath inTableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Viewport *viewport = [_searchResults objectAtIndex:indexPath.row];
        _curData=[viewport getData];
        [self performSegueWithIdentifier:@"gotoDetail" sender:self];
        return;
    }
    Viewport *viewport = [self.fetchedResultsController objectAtIndexPath:indexPath];
    _curData=[viewport getData];
    [self performSegueWithIdentifier:@"gotoDetail" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setValue:_curData forKey:@"curData"];
}

- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)style
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (style == UITableViewCellEditingStyleDelete) {
        NSFetchedResultsController *controller = self.fetchedResultsController;
        NSManagedObjectContext *context = [controller managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tv canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Viewport"
                inManagedObjectContext:context];
    NSSortDescriptor *dateSort =
    [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setSortDescriptors:
     [NSArray arrayWithObjects:dateSort, nil]];
    
    _fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(JingdianCell*)[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath
                    inTableView:tableView];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)configureCell:(JingdianCell *)cell atIndexPath:(NSIndexPath *)indexPath
          inTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Viewport *viewport = [_searchResults objectAtIndex:indexPath.row];
        [cell createView:[viewport getData]];
        return;
    }
    Viewport *viewport = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell createView:[viewport getData]];
}

@end
