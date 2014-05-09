//
//  MasterViewController.h
//  TodoList
//
//  Created by BoranA on 04/11/13.
//  Copyright (c) 2013 BoranA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectCategoryView.h"

@class DetailViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, SelectCategoryDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *titleTxt;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton    *addBtn;

- (IBAction)insertNewObject:(id)sender;
- (void)testInsertNewObject:(int)index;

@end
