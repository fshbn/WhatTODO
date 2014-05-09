//
//  DetailViewController.h
//  TodoList
//
//  Created by BoranA on 04/11/13.
//  Copyright (c) 2013 BoranA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TodoListItem.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) TodoListItem *detailItem;

@property (weak, nonatomic) IBOutlet UITextView *notesTxtView;
@end
