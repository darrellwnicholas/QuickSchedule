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

- (NSMutableArray *)daysArray
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dayNumber" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    _daysArray = [[_daysArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    return _daysArray;
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
    // shared app group ID
    NSString *groupID = @"group.YAZVT7PQ49.com.darrellnicholas.QuickSchedule";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // grabbing a URL and simulataneously changing it to a string.
    NSString *groupPath = [[fileManager containerURLForSecurityApplicationGroupIdentifier:groupID] absoluteString];
    // stripping off the slashes from the URL
    NSString *newGroupPath = [groupPath substringWithRange:NSMakeRange(6, [groupPath length]-6)];

    return [newGroupPath stringByAppendingPathComponent:@"days.plist"];
}

- (NSString *)employeeArchivePath
{
    // shared app group ID
    NSString *groupID = @"group.YAZVT7PQ49.com.darrellnicholas.QuickSchedule";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // grabbing a URL and simulataneously changing it to a string.
    NSString *groupPath = [[fileManager containerURLForSecurityApplicationGroupIdentifier:groupID] absoluteString];
    // stripping off the slashes from the URL
    NSString *newGroupPath = [groupPath substringWithRange:NSMakeRange(6, [groupPath length]-6)];
    return [newGroupPath stringByAppendingPathComponent:@"employees.plist"];
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
    // Shared App Group Identifier
    NSString *groupID = @"group.YAZVT7PQ49.com.darrellnicholas.QuickSchedule";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // creating a URL to the App Group
    NSURL *path = [fileManager containerURLForSecurityApplicationGroupIdentifier:groupID];
    // changing the URL to a String because this app used string paths instead of URLs so it's just easier to keep it this way
    NSString *itemPath = [[path URLByAppendingPathComponent:@"days.plist"] absoluteString];
    NSString *empPath = [[path URLByAppendingPathComponent:@"employees.plist"] absoluteString];

    // I have to strip off the "file://" from the URL to make it work as a string. It ends up creating a string with 2 "//"s at the
    // beginning, but for some reason, it still converts it to just a single slash so I'm not messing with it at this time, maybe
    // later I will come back and see if I can adjust the following from "6 and -6" to "7 and -7" or whatever, but for now, ios
    // is handling it, and I will let it. I am making this comment in case Apple changes something in the future and this causes
    // issues. -Darrell 4/8/2015
    return ([NSKeyedArchiver archiveRootObject:self.daysArray toFile:[itemPath substringWithRange:NSMakeRange(6, [itemPath length]-6)]] && [NSKeyedArchiver archiveRootObject:self.masterEmployeeList toFile:[empPath substringWithRange:NSMakeRange(6, [empPath length]-6)]]);
}

- (Employee *)createEmployeeWithFirstName:(NSString*)first andLastName:(NSString*)last andEmail:(NSString *)email
{
    Employee *employee = [[Employee alloc] initWithFirstName:first lastName:last email:email];
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

- (void)calculateHoursForEmployee:(Employee *)emp
{
    emp.hours = 0;
    for (WorkDay *day in self.daysArray) {
        for (WorkShift *shift in day.shifts) {
            if ([shift.assignedEmployee.description isEqualToString:emp.description]) {
                emp.hours += shift.hours;
            }
        }
    }
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

/*
 COMMENTS REMOVED FROM EMPLOYEE AND ITEMARCHIVE PATH METHODS
 
 //    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 //    NSString *documentDirectory = [documentsDirectories objectAtIndex:0];
 //    return [documentDirectory stringByAppendingPathComponent:@"days.plist"];
 //    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 //    NSString *documentDirectory = [documentsDirectories objectAtIndex:0];
 //    return [documentDirectory stringByAppendingPathComponent:@"employees.plist"];
 //NSLog(@"groupPath before adding employees.plist = %@", [fileManager containerURLForSecurityApplicationGroupIdentifier:groupID]);
 
 
 COMMENTS REMOVED FROM SAVECHANGES METHOD
 
 //    NSString *path = [self itemArchivePath];
 //    NSString *empPath = [self employeeArchivePath];
 //NSLog(@"Employee absoluteString Path = %@", [empPath absoluteString]);
 
 COMMENT REMOVED FROM INIT
 
 //        NSSortDescriptor *sortDescriptor;
 //        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dayNumber" ascending:YES];
 //        NSArray *sortDescriptors = @[sortDescriptor];
 //        _daysArray = [[_daysArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];

 */

@end
