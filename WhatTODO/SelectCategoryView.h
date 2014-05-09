//
//  SelectCategoryView.h
//  TodoList
//
//  Created by BoranA on 07/11/13.
//  Copyright (c) 2013 BoranA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TodoCell.h"

@protocol SelectCategoryDelegate <NSObject>

- (void)categorySelected:(int)category ForCell:(TodoCell*)cell;

@end

@interface SelectCategoryView : UIView {
    __unsafe_unretained id<SelectCategoryDelegate> delegate;
}

@property (nonatomic, assign) id<SelectCategoryDelegate> delegate;
@property (nonatomic, strong) TodoCell                  *ownerCell;
@property (nonatomic, strong) IBOutlet UIControl        *blueCtrl;
@property (nonatomic, strong) IBOutlet UIControl        *yellowCtrl;
@property (nonatomic, strong) IBOutlet UIControl        *greenCtrl;
@property (nonatomic, strong) IBOutlet UIControl        *redCtrl;

@end
