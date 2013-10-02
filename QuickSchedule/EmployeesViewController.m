//
//  EmployeesViewController.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/11/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "EmployeesViewController.h"
#import "AddEmployeeViewController.h"
#import "EmployeeDataController.h"
#import "ScheduleViewController.h"

@interface EmployeesViewController ()

@end

@implementation EmployeesViewController


- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem.accessibilityHint = @"Adds a new employee";
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[MyManager sharedManager] saveChanges];
}


- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        AddEmployeeViewController *addController = [segue sourceViewController];
        if (addController.employee) {
            [[MyManager sharedManager] saveChanges];
            [[self tableView] reloadData];
        }
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[MyManager sharedManager] countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EmployeeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Employee *employeeAtIndex = [[MyManager sharedManager] objectInListAtIndex:indexPath.row];
    cell.textLabel.text = [employeeAtIndex description];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        MyManager *sharedManager = [MyManager sharedManager];
        Employee *tmp = [sharedManager.masterEmployeeList objectAtIndex:indexPath.row];
        // Go through and set assignedEmployee that matches tmp to nil.
        
        for (WorkDay *day in sharedManager.daysArray) {
            for (WorkShift *shift in day.shifts) {
                if ([shift.assignedEmployee.description isEqualToString:tmp.description]) {
                    shift.assignedEmployee = nil;
                }
            }
        }
        tmp = nil;
        [sharedManager saveChanges];
        [sharedManager.masterEmployeeList removeObjectAtIndex:indexPath.row];
      
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[MyManager sharedManager] countOfList]) {
        return @"Tap Employee to Assign to Shift";
    } else {
        return @"Tap \"+\" to add Employees";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.activeShift setAssignedEmployee:[[MyManager sharedManager] objectInListAtIndex:indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end
