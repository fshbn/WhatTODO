//
//  TodoListTests.m
//  TodoListTests
//
//  Created by BoranA on 04/11/13.
//  Copyright (c) 2013 BoranA. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MasterViewController.h"

@interface TodoListTests : XCTestCase

@end

@implementation TodoListTests {
    NSManagedObjectContext* _moc;
    MasterViewController* _masterViewController;
}

- (void)setUp
{
    [super setUp];

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TodoList" withExtension:@"momd"];
    NSManagedObjectModel* mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"TodoList.sqlite"];
    
    XCTAssert([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    _moc = [[NSManagedObjectContext alloc] init];
    _moc.persistentStoreCoordinator = psc;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        _masterViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil]instantiateViewControllerWithIdentifier:@"MasterViewController_iPad"];
    } else {
        _masterViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil]instantiateViewControllerWithIdentifier:@"MasterViewController"];
    }
    
    _masterViewController.managedObjectContext = _moc;
}

- (void)tearDown
{
    [super tearDown];
    _masterViewController = nil;
    _moc = nil;
}

- (void)testExample
{
    for (int i = 0; i < 100; i++) {
        [_masterViewController testInsertNewObject:i];
    }
}

@end
