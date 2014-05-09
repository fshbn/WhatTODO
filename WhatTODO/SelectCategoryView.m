//
//  SelectCategoryView.m
//  TodoList
//
//  Created by BoranA on 07/11/13.
//  Copyright (c) 2013 BoranA. All rights reserved.
//

#import "SelectCategoryView.h"
#import "UIColor+CategoryColor.h"
#import "Constants.h"

@implementation SelectCategoryView
@synthesize delegate, ownerCell;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor grayColor]];
        
        float categoryWidht = frame.size.width/4;
        
        self.greenCtrl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, categoryWidht, 64)];
        [self.greenCtrl setBackgroundColor:[UIColor categoryColor:CAT_GREEN]];
        self.greenCtrl.tag = CAT_GREEN;
        
        self.yellowCtrl = [[UIControl alloc] initWithFrame:CGRectMake(categoryWidht, 0, categoryWidht, 64)];
        [self.yellowCtrl setBackgroundColor:[UIColor categoryColor:CAT_YELLOW]];
        self.yellowCtrl.tag = CAT_YELLOW;
        
        self.blueCtrl = [[UIControl alloc] initWithFrame:CGRectMake(categoryWidht*2, 0, categoryWidht, 64)];
        [self.blueCtrl setBackgroundColor:[UIColor categoryColor:CAT_BLUE]];
        self.blueCtrl.tag = CAT_BLUE;
        
        self.redCtrl = [[UIControl alloc] initWithFrame:CGRectMake(categoryWidht*3, 0, categoryWidht, 64)];
        [self.redCtrl setBackgroundColor:[UIColor categoryColor:CAT_RED]];
        self.redCtrl.tag = CAT_RED;
        
        [self.greenCtrl addTarget:self
                           action:@selector(categorySelected:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [self.yellowCtrl addTarget:self
                            action:@selector(categorySelected:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.blueCtrl addTarget:self
                          action:@selector(categorySelected:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.redCtrl addTarget:self
                         action:@selector(categorySelected:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.blueCtrl];
        [self addSubview:self.yellowCtrl];
        [self addSubview:self.greenCtrl];
        [self addSubview:self.redCtrl];
    }
    return self;
}

- (void)categorySelected:(id)sender {
    UIControl *selectedControl = sender;
    [UIView animateWithDuration:0.2 animations:^(void){
        [self setAlpha:0.0];
        [self setFrame:CGRectMake(-320, 0, 320, 64)];
    }];
    
    [delegate categorySelected:selectedControl.tag ForCell:ownerCell];
}

@end
