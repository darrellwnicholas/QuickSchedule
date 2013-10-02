//
//  ScheduleViewController.h
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/11/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkDay.h"
#import "WorkShift.h"

@interface ScheduleViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *daysArray;

- (IBAction)done:(UIStoryboardSegue *)segue;

@end
