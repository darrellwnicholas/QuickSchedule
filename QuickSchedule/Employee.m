//
//  Employee.m
//  Debbers Schedule
//
//  Created by Darrell on 8/3/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "Employee.h"

@implementation Employee
@synthesize firstName, lastName;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

- (id)initWithFirstName:(NSString *)first lastName:(NSString *)last
{
    self = [super init];
    if (self) {
        firstName = first;
        lastName = last;
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstnamekey"];
    [aCoder encodeObject:self.lastName forKey:@"lastnamekey"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.firstName = [aDecoder decodeObjectForKey:@"firstnamekey"];
    self.lastName = [aDecoder decodeObjectForKey:@"lastnamekey"];
    
    return self;
}

@end
