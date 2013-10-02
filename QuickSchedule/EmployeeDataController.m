//
//  EmployeeDataController.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/17/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "EmployeeDataController.h"
#import "Employee.h"

@interface EmployeeDataController ()

- (void)initializeEmployeeList;

@end

@implementation EmployeeDataController

- (void)initializeEmployeeList {
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docDirectory stringByAppendingPathComponent:@"employee.plist"];
    NSMutableArray *storedMasterEmployeeList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (storedMasterEmployeeList) {
        self.masterEmployeeList = storedMasterEmployeeList;
    } else {
        NSMutableArray *employeeList = [[NSMutableArray alloc] init];
        self.masterEmployeeList = employeeList;
    }
}

- (void)setMasterEmployeeList:(NSMutableArray *)newList {
    if (_masterEmployeeList != newList) {
        _masterEmployeeList = [newList mutableCopy];
    }
}

- (id)init {
    if (self = [super init]) {
        [self initializeEmployeeList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList {
    return [self.masterEmployeeList count];
}

- (Employee *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.masterEmployeeList objectAtIndex:theIndex];
}

- (void)addEmployeeToList:(Employee *)newEmployee {
    [self.masterEmployeeList addObject:newEmployee];
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.masterEmployeeList forKey:@"employeeListKey"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.masterEmployeeList = [decoder decodeObjectForKey:@"employeeListKey"];
    
    return self;
}

@end
