//
//  ScheduleViewController.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/11/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "ScheduleViewController.h"
#import "EmployeesViewController.h"
#import "EditShiftsViewController.h"
#import "MyManager.h"

@interface ScheduleViewController ()


@end

@implementation ScheduleViewController
@synthesize daysArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[MyManager sharedManager] saveChanges];
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Schedule";
    [self.navigationController.toolbar setTranslucent:NO];
    [self.navigationController.toolbar setTintColor:[UIColor colorWithRed:0.25 green:0.4 blue:0.4 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.25 green:0.4 blue:0.4 alpha:1.0]];
    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.95 alpha:0.4]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.95 alpha:0.4]];
    
    //UIToolbar *toolbar;
    //[toolbar setBarTintColor:[UIColor greenColor]];
    //[toolbar setTranslucent:NO];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"DoneEditing"]) {
        [[MyManager sharedManager] saveChanges];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[MyManager sharedManager] daysArray] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [[[self.daysArray objectAtIndex:section] shifts] count];
    return [[[[[MyManager sharedManager] daysArray] objectAtIndex:section] shifts] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [[self.daysArray objectAtIndex:section] name];
    return [[[[MyManager sharedManager] daysArray] objectAtIndex:section] name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //WorkDay *day = [self.daysArray objectAtIndex:indexPath.section];
    WorkDay *day = [[[MyManager sharedManager] daysArray] objectAtIndex:indexPath.section];
    WorkShift *shift = [day.shifts objectAtIndex:indexPath.row];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %@ - %@", shift.shiftName,
                                 [df stringFromDate:shift.startTime], [df stringFromDate:shift.endTime]];
    
    
    cell.textLabel.text = [[[day.shifts objectAtIndex:indexPath.row] assignedEmployee] description];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ChooseEmployee"]) {
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        WorkDay *day = [[[MyManager sharedManager] daysArray] objectAtIndex:path.section];
        WorkShift *thisShift = [day.shifts objectAtIndex:path.row];
        
        EmployeesViewController *employeeController = [segue destinationViewController];
        [employeeController setActiveShift:thisShift];
    } else if ([[segue identifier] isEqualToString:@"EditShiftsSegue"]) {
        
        
    }
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Unassign";
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)path
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *updateIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:path.row inSection:path.section], nil];
        WorkDay *thisDay = [[[MyManager sharedManager]daysArray] objectAtIndex:path.section];
        WorkShift *thisShift = [thisDay.shifts objectAtIndex:path.row];
        thisShift.assignedEmployee.hours -= thisShift.hours;
        thisShift.assignedEmployee = nil;
        [[MyManager sharedManager] saveChanges];
        [self.tableView reloadRowsAtIndexPaths:updateIndexPaths
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } 
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


     
#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (NSString *)stringFromHours:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hour = (ti / 3600);
    return [NSString stringWithFormat:@"%i:%02i Hours", hour, minutes];
}
- (IBAction)shareSchedule:(id)sender {

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterNoStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    //NSMutableArray *bobsDays = [[NSMutableArray alloc] init];

    NSString *scheduleString = @"";
    

    
    for (WorkDay *day in [[MyManager sharedManager] daysArray]) {
        NSString *dayString = [NSString stringWithFormat:@"----\n%@\n", day.name];
        scheduleString = [scheduleString stringByAppendingString:dayString];
        
        for (WorkShift *shift in day.shifts) {
            if (shift.assignedEmployee != nil) {
                NSString *shiftString = [NSString stringWithFormat:@"%@: %@\n %@ - %@\n", shift.shiftName, shift.assignedEmployee.description, [df stringFromDate:shift.startTime], [df stringFromDate:shift.endTime]];
                scheduleString = [scheduleString stringByAppendingString:shiftString];
            } else if (shift.assignedEmployee == nil){
            NSString *shiftString = [NSString stringWithFormat:@"%@: **NOT YET ASSIGNED**\n %@ - %@\n", shift.shiftName, [df stringFromDate:shift.startTime], [df stringFromDate:shift.endTime]];
            scheduleString = [scheduleString stringByAppendingString:shiftString];
            }
                //NSLog(@"  (%@ to %@)\n",[df stringFromDate:shift.startTime], [df stringFromDate:shift.endTime]);
                //NSLog(@" Assigned Employee: %@", shift.assignedEmployee.description);
            
        }
    }
    NSString *totalHrsHeader = @"--------\n--------\nTotal Assigned Hours:\n----\n";
    scheduleString = [scheduleString stringByAppendingString:totalHrsHeader];
    for (Employee *emp in [[MyManager sharedManager] masterEmployeeList]) {
        NSString *hourString = [self stringFromHours:emp.hours];
        NSString *empString = [NSString stringWithFormat:@"%@, scheduled for %@\n", emp.description, hourString];
        scheduleString = [scheduleString stringByAppendingString:empString];
    }
    
    scheduleString = [scheduleString stringByAppendingString:@"\n\nMade with QuickSchedule™\n"];
    
    //NSLog(@"%@", scheduleString);
    NSMutableArray *addresses = [[NSMutableArray alloc]init];
    for (Employee *emp in [[MyManager sharedManager] masterEmployeeList]) {
        [addresses addObject:emp.email];
    }
    
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setToRecipients:addresses];
    [mailComposer setSubject:@"Schedule"];
    [mailComposer setMessageBody:scheduleString isHTML:NO];
    
     [self presentViewController:mailComposer animated:YES completion:nil];

}
@end
