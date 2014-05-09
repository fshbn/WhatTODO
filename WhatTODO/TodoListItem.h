//
//  TodoListItem.h
//  WhatTODO
//
//  Created by BoranA on 08/05/14.
//  Copyright (c) 2014 BoranA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TodoListItem : NSManagedObject

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * title;

@end
