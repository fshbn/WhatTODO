//
//  DetailViewController.m
//  TodoList
//
//  Created by BoranA on 04/11/13.
//  Copyright (c) 2013 BoranA. All rights reserved.
//

#import "DetailViewController.h"

#import "UIColor+CategoryColor.h"

@interface DetailViewController () {
    BOOL isShowingLandscapeView;
    UIBarButtonItem *saveBtn;
}

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConst;
@property (weak, nonatomic) IBOutlet UIView *titleFooterView;

- (void)configureView;
- (void)observeKeyboard;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(TodoListItem*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    if (self.detailItem) {
        [self.titleFooterView setBackgroundColor:[UIColor categoryColor:[self.detailItem.category integerValue]]];
        
        self.notesTxtView.text = self.detailItem.desc;
        self.title = self.detailItem.title;
        [self.notesTxtView setEditable:YES];
        [saveBtn setEnabled:YES];
    } else {
        [self.notesTxtView setEditable:NO];
        [saveBtn setEnabled:NO];
    }
}

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveContext)];
        
        self.navigationItem.rightBarButtonItem = saveBtn;
    }

    self.notesTxtView.delegate = self;
    [self configureView];
    [self observeKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGRect finalKeyboardFrame = [self.view convertRect:keyboardFrame fromView:self.view.window];

    int kbHeight = finalKeyboardFrame.size.height;
    
    int height = kbHeight + self.textViewBottomConst.constant;
    
    self.textViewBottomConst.constant = height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.textViewBottomConst.constant = 10;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"WhatTODO", @"WhatTODO");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self saveContext];
    }
    
    [super viewWillDisappear:animated];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self saveContext];
}

- (void)saveContext {
    self.detailItem.desc = self.notesTxtView.text;
    
    if ([self.detailItem.managedObjectContext hasChanges]) {
        NSError *error = nil;
        if (![self.detailItem.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

-(void) viewDidDisappear {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
