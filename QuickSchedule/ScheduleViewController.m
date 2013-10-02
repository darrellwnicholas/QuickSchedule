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
    self.daysArray = [[MyManager sharedManager] daysArray];

    self.title = @"Schedule";
    WorkDay *tmp = [daysArray objectAtIndex:0];
    WorkShift *shft = [tmp.shifts objectAtIndex:0];
    NSLog(@"Monday Shift 1 length: %@", [shft stringFromTimeInterval:shft.hours]);




    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"DoneEditing"]) {
        [[MyManager sharedManager] saveChanges];
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
    return [self.daysArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.daysArray objectAtIndex:section] shifts] count];
    //return [[[[[MyManager sharedManager] daysArray] objectAtIndex:section] shifts] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.daysArray objectAtIndex:section] name];
    //return [[[[MyManager sharedManager] daysArray] objectAtIndex:section] name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    WorkDay *day = [self.daysArray objectAtIndex:indexPath.section];
    //WorkDay *day = [[MyManager sharedManager] daysArray] objectAtIndex:indexPath.section];
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
        WorkDay *day = [self.daysArray objectAtIndex:path.section];
        WorkShift *thisShift = [day.shifts objectAtIndex:path.row];
        
        EmployeesViewController *employeeController = [segue destinationViewController];
        [employeeController setActiveShift:thisShift];
    } else if ([[segue identifier] isEqualToString:@"EditShiftsSegue"]) {
        
        
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Unassign";
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        WorkDay *thisDay = [self.daysArray objectAtIndex:indexPath.section];
        WorkShift *thisShift = [thisDay.shifts objectAtIndex:indexPath.row];
        thisShift.assignedEmployee = nil;
        [[MyManager sharedManager] saveChanges];
        [self.tableView reloadData];
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


@end
