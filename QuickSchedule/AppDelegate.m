//
//  AppDelegate.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/11/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "AppDelegate.h"
#import "WorkDay.h"
#import "WorkShift.h"
#import "ScheduleViewController.h"
#import "MyManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasBeenLaunched"]) {
        [self configureDays];
    }
    return YES;
}

- (void)configureDays
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *startTime1 = @"6:00 AM";
    NSString *startTime2 = @"2:00 PM";
    NSString *endTime1 = startTime2;
    NSString *endTime2 = @"10:00 PM";
    
    MyManager *sharedManager = [MyManager sharedManager];
    WorkDay *mon = [sharedManager createDay];
    mon.name = @"Monday";
    mon.dayNumber = 0;
    WorkShift *shift = [sharedManager createShift];
    shift.shiftName = @"Shift 1";
    WorkShift *shift2 = [sharedManager createShift];
    shift2.shiftName = @"Shift 2";
    shift.startTime = [dateFormatter dateFromString:startTime1];
    shift.endTime = [dateFormatter dateFromString:endTime1];
    shift2.startTime = [dateFormatter dateFromString:startTime2];
    shift2.endTime = [dateFormatter dateFromString:endTime2];
    [mon.shifts addObject:shift];
    [mon.shifts addObject:shift2];
    
    WorkDay *tues = [sharedManager createDay];
    tues.name = @"Tuesday";
    tues.dayNumber = 1;
    WorkShift *shift3 = [sharedManager createShift];
    shift3.shiftName = @"Shift 1";
    WorkShift *shift4 = [sharedManager createShift];
    shift4.shiftName = @"Shift 2";
    shift3.startTime = [dateFormatter dateFromString:startTime1];
    shift3.endTime = [dateFormatter dateFromString:endTime1];
    shift4.startTime = [dateFormatter dateFromString:startTime2];
    shift4.endTime = [dateFormatter dateFromString:endTime2];
    [tues.shifts addObject:shift3];
    [tues.shifts addObject:shift4];
    
    WorkDay *wed = [sharedManager createDay];
    wed.name = @"Wednesday";
    wed.dayNumber = 2;
    WorkShift *shift5 = [sharedManager createShift];
    shift5.shiftName = @"Shift 1";
    WorkShift *shift6 = [sharedManager createShift];
    shift6.shiftName = @"Shift 2";
    shift5.startTime = [dateFormatter dateFromString:startTime1];
    shift5.endTime = [dateFormatter dateFromString:endTime1];
    shift6.startTime = [dateFormatter dateFromString:startTime2];
    shift6.endTime = [dateFormatter dateFromString:endTime2];
    [wed.shifts addObject:shift5];
    [wed.shifts addObject:shift6];
    
    WorkDay *thurs = [sharedManager createDay];
    thurs.name = @"Thursday";
    thurs.dayNumber = 3;
    WorkShift *shift7 = [sharedManager createShift];
    shift7.shiftName = @"Shift 1";
    WorkShift *shift8 = [sharedManager createShift];
    shift8.shiftName = @"Shift 2";
    shift7.startTime = [dateFormatter dateFromString:startTime1];
    shift7.endTime = [dateFormatter dateFromString:endTime1];
    shift8.startTime = [dateFormatter dateFromString:startTime2];
    shift8.endTime = [dateFormatter dateFromString:endTime2];
    [thurs.shifts addObject:shift7];
    [thurs.shifts addObject:shift8];
    
    WorkDay *friday = [sharedManager createDay];
    friday.name = @"Friday";
    friday.dayNumber = 4;
    WorkShift *shift9 = [sharedManager createShift];
    shift9.shiftName = @"Shift 1";
    WorkShift *shift10 = [sharedManager createShift];
    shift10.shiftName = @"Shift 2";
    shift9.startTime = [dateFormatter dateFromString:startTime1];
    shift9.endTime = [dateFormatter dateFromString:endTime1];
    shift10.startTime = [dateFormatter dateFromString:startTime2];
    shift10.endTime = [dateFormatter dateFromString:endTime2];
    [friday.shifts addObject:shift9];
    [friday.shifts addObject:shift10];
    
    WorkDay *sat = [sharedManager createDay];
    sat.name = @"Saturday";
    sat.dayNumber = 5;
    WorkShift *shift11 = [sharedManager createShift];
    shift11.shiftName = @"Shift 1";
    WorkShift *shift12 = [sharedManager createShift];
    shift12.shiftName = @"Shift 2";
    shift11.startTime = [dateFormatter dateFromString:startTime1];
    shift11.endTime = [dateFormatter dateFromString:endTime1];
    shift12.startTime = [dateFormatter dateFromString:startTime2];
    shift12.endTime = [dateFormatter dateFromString:endTime2];
    [sat.shifts addObject:shift11];
    [sat.shifts addObject:shift12];
    
    WorkDay *sun = [sharedManager createDay];
    sun.name = @"Sunday";
    sun.dayNumber = 6;
    WorkShift *shift13 = [sharedManager createShift];
    shift13.shiftName = @"Shift 1";
    WorkShift *shift14 = [sharedManager createShift];
    shift14.shiftName = @"Shift 2";
    shift13.startTime = [dateFormatter dateFromString:startTime1];
    shift13.endTime = [dateFormatter dateFromString:endTime1];
    shift14.startTime = [dateFormatter dateFromString:startTime2];
    shift14.endTime = [dateFormatter dateFromString:endTime2];
    [sun.shifts addObject:shift13];
    [sun.shifts addObject:shift14];

    NSMutableArray *archivedDaysArray = [[NSMutableArray alloc] initWithObjects:mon, tues, wed, thurs, friday, sat, sun, nil];
    sharedManager.daysArray = archivedDaysArray;
    if (![sharedManager saveChanges]) {
        NSLog(@"Did not save.");
    } else {
        NSLog(@"Saved");
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasBeenLaunched"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
