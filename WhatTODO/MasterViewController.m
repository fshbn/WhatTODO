//
//  MasterViewController.m
//  TodoList
//
//  Created by BoranA on 04/11/13.
//  Copyright (c) 2013 BoranA. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "TodoCell.h"

#import "TodoListItem.h"

#import "SelectCategoryView.h"

#import "UIColor+CategoryColor.h"

#import "Constants.h"

@interface MasterViewController () {
    UIBarButtonItem *editButton;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(commitEditing)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self.titleTxt setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && [[self.fetchedResultsController sections] count] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        self.detailViewController.detailItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.titleTxt resignFirstResponder];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.titleTxt becomeFirstResponder];
}

- (IBAction)insertNewObject:(id)sender
{
    [self.view endEditing:YES];
    
    if ([self.titleTxt.text length] > 0) {
        @autoreleasepool {
            NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
            NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
            TodoListItem *newManagedObject = (TodoListItem*)[NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
            
            newManagedObject.title = self.titleTxt.text;
            newManagedObject.category = [NSNumber numberWithInt:1];
            newManagedObject.done = [NSNumber numberWithBool:NO];
            
            NSArray *listItems = [self.fetchedResultsController fetchedObjects];
            NSNumber *lastIndex = [listItems valueForKeyPath:@"@max.order"];
            
            newManagedObject.order = [NSNumber numberWithInt:[lastIndex intValue]+1];
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
        
        self.titleTxt.text = @"";
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please define a title for your list item." delegate:self cancelButtonTitle:@"Got it!" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodoCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(TodoCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TodoListItem *listObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIView *selectCategoryView = [cell viewWithTag:101];
    if (selectCategoryView) {
        [selectCategoryView removeFromSuperview];
    }
        
    cell.titleLbl.text = listObject.title;
    
    [cell.categoryCtrl addTarget:self
                          action:@selector(selectItemCategory:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [cell.completedBtn addTarget:self
                          action:@selector(todoItemCompleted:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [cell.categoryCtrl setBackgroundColor:[UIColor categoryColor:[listObject.category integerValue]]];
    
    if (!self.tableView.isEditing) {
        [cell.completedBtn setHidden:NO];
    } else {
        [cell.completedBtn setHidden:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoCell *cell = (TodoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if (self.tableView.isEditing)
        [cell.completedBtn setHidden:YES];
    else
        [cell.completedBtn setHidden:NO];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoCell *cell = (TodoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if (self.tableView.isEditing)
        [cell.completedBtn setHidden:YES];
    else
        [cell.completedBtn setHidden:NO];
}

- (void)commitEditing {
    if (self.tableView.isEditing) {
        editButton.title = @"Edit";
        [self.addBtn setEnabled:YES];
        [self.tableView setEditing:NO animated:YES];
        [self.titleTxt setEnabled:YES];
        if ([self.managedObjectContext hasChanges]) {
            NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
    } else {
        editButton.title = @"Done";
        
        for (TodoCell *cell in self.tableView.visibleCells) {
            UIView *selectCategoryView = [cell viewWithTag:101];
            if (selectCategoryView) {
                [selectCategoryView removeFromSuperview];
            }
        }
        
        [self.addBtn setEnabled:NO];
        [self.titleTxt setEnabled:NO];
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    @autoreleasepool {
        TodoListItem *sourceItem = [self.fetchedResultsController objectAtIndexPath:sourceIndexPath];
        TodoListItem *destinationItem = [self.fetchedResultsController objectAtIndexPath:destinationIndexPath];
        
        int direction = sourceIndexPath.row - destinationIndexPath.row;
        
        //Delta update checks
        if (direction > 0) {
            for (int s = sourceIndexPath.row-1; s >= destinationIndexPath.row; s--) {
                TodoListItem *item = (TodoListItem*)[self.fetchedResultsController.fetchedObjects objectAtIndex:s];
                item.order = [NSNumber numberWithInt:[item.order intValue]-1];
            }
            
            sourceItem.order = [NSNumber numberWithInt:[destinationItem.order intValue]+1];;
        } else if (direction < 0) {
            for (int s = sourceIndexPath.row+1; s <= destinationIndexPath.row; s++) {
                TodoListItem *item = (TodoListItem*)[self.fetchedResultsController.fetchedObjects objectAtIndex:s];
                item.order = [NSNumber numberWithInt:[item.order intValue]+1];
            }
            
            sourceItem.order = [NSNumber numberWithInt:[destinationItem.order intValue]-1];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        TodoListItem *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TodoListItem *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TodoListItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"done = 0"];
    [fetchRequest setPredicate:pred];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Cell Category Selection

- (void)selectItemCategory:(id)sender {
    if (!self.tableView.isEditing) {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        
        if (indexPath != nil)
        {            
            TodoCell *cell = (TodoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            float cellWidth = cell.frame.size.width;
            
            SelectCategoryView *selectCategoryView = [[SelectCategoryView alloc] initWithFrame:CGRectMake(-cellWidth, 0, cellWidth, 64)];
            
            selectCategoryView.delegate = self;
            selectCategoryView.ownerCell = cell;
            selectCategoryView.tag = 101;
            
            [selectCategoryView setAlpha:0.0];
            [cell.contentView addSubview:selectCategoryView];
            
            [UIView animateWithDuration:0.2 animations:^(void){
                [selectCategoryView setAlpha:1.0];
                [selectCategoryView setFrame:CGRectMake(0, 0, cellWidth, 64)];
            }];
        }
    }
}

- (void)categorySelected:(int)category ForCell:(TodoCell*)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TodoListItem *listItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    listItem.category = [NSNumber numberWithInt:category];
    
    [cell.categoryCtrl setBackgroundColor:[UIColor categoryColor:category]];
    
    NSError *error = nil;
	if (![listItem.managedObjectContext save:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

- (void)todoItemCompleted:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    TodoListItem *listItem = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    listItem.done = [NSNumber numberWithBool:YES];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

#pragma mark - Tests

- (void)testInsertNewObject:(int)index
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    TodoListItem *newManagedObject = (TodoListItem*)[NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    newManagedObject.title = [NSString stringWithFormat:@"%i", index];
    newManagedObject.category = [NSNumber numberWithInt:1];
    newManagedObject.done = [NSNumber numberWithBool:NO];
    newManagedObject.order = [NSNumber numberWithInt:index];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

@end
