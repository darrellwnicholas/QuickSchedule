//
//  EmployeeDataController.h
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/17/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Employee;

@interface EmployeeDataController : NSObject <NSCoding>

@property (nonatomic, copy) NSMutableArray *masterEmployeeList;

- (NSUInteger)countOfList;
- (Employee *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addEmployeeToList:(Employee *)newEmployee;

@end
