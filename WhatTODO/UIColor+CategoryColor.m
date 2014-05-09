//
//  UIColor+CategoryColor.m
//  TodoList
//
//  Created by BoranA on 07/11/13.
//  Copyright (c) 2013 BoranA. All rights reserved.
//

#import "UIColor+CategoryColor.h"
#import "Constants.h"

@implementation UIColor (CategoryColor)

+ (UIColor*)categoryColor:(int)categoryId {
    UIColor *color;
    switch (categoryId) {
        case CAT_GREEN:
            color = [UIColor colorWithRed:76/255.0f green:217/255.0f blue:100/255.0f alpha:1.0f];
            break;
        case CAT_YELLOW:
            color = [UIColor colorWithRed:255/255.0f green:204/255.0f blue:0/255.0f alpha:1.0f];
            break;
        case CAT_BLUE:
            color = [UIColor colorWithRed:90/255.0f green:200/255.0f blue:250/255.0f alpha:1.0f];
            break;
        case CAT_RED:
            color = [UIColor colorWithRed:255/255.0f green:59/255.0f blue:48/255.0f alpha:1.0f];
            break;
        default:
            break;
    }
    return color;
}

@end
