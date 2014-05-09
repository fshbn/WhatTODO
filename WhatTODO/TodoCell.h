//
//  TodoCell.h
//  TodoList
//
//  Created by BoranA on 06/11/13.
//  Copyright (c) 2013 BoranA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel    *titleLbl;
@property (nonatomic, weak) IBOutlet UIControl  *categoryCtrl;
@property (nonatomic, weak) IBOutlet UIButton   *completedBtn;

@end
