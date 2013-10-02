//
//  MyManager.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 9/17/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "MyManager.h"

@interface MyManager ()

- (void)initializeEmployeeList;

@end

@implementation MyManager
@synthesize masterEmployeeList;

+ (MyManager *)sharedManager
{
    static MyManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}


- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _daysArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        [self initializeEmployeeList];
    }
    return self;
}

- (void)initializeEmployeeList
{
    NSString *path = [self employeeArchivePath];
    NSMutableArray *storedMasterEmployeeList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (storedMasterEmployeeList) {
        self.masterEmployeeList = storedMasterEmployeeList;
    } else {
        NSMutableArray *employeeList = [[NSMutableArray alloc] init];
        self.masterEmployeeList = employeeList;
    }
}

- (NSString *)itemArchivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentsDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"days.plist"];
}

- (NSString *)employeeArchivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentsDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"employees.plist"];
}

- (void)setMasterEmployeeList:(NSMutableArray *)newMasterEmployeeList
{
    if (masterEmployeeList != newMasterEmployeeList) {
        masterEmployeeList = [newMasterEmployeeList mutableCopy];
    }
}

- (NSMutableArray *)masterEmployeeList
{
    return masterEmployeeList;
}

- (WorkDay *)createDay
{
    WorkDay *d = [[WorkDay alloc] init];
    [self.daysArray addObject:d];
    return d;
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    NSString *empPath = [self employeeArchivePath];
    return ([NSKeyedArchiver archiveRootObject:self.daysArray toFile:path] && [NSKeyedArchiver archiveRootObject:self.masterEmployeeList toFile:empPath]);
}

- (Employee *)createEmployeeWithFirstName:(NSString*)first andLastName:(NSString*)last
{
    Employee *employee = [[Employee alloc] initWithFirstName:first lastName:last];
    return employee;
}
- (WorkShift *)createShift
{
    WorkShift *shift = [[WorkShift alloc] init];
    return shift;
}
- (void)assignEmployee:(Employee*)employee toShift:(WorkShift*)shift
{
    shift.assignedEmployee = employee;
}

- (void)addEmployeeToList:(Employee *)newEmployee {
    [self.masterEmployeeList addObject:newEmployee];
}

- (NSUInteger)countOfList {
    return [self.masterEmployeeList count];
}

- (Employee *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.masterEmployeeList objectAtIndex:theIndex];
}

- (void)removeEmployee:(Employee *)emp
{
    [self.masterEmployeeList removeObjectIdenticalTo:emp];
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
