//
//  AddTodoCell.h
//  TodoList
//
//  Created by BoranA on 06/11/13.
//  Copyright (c) 2013 BoranA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTodoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField    *titleTxt;
@property (nonatomic, weak) IBOutlet UIButton       *addBtn;

@end
