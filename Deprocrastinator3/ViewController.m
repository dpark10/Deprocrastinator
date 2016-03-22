//
//  ViewController.m
//  Deprocrastinator3
//
//  Created by dp on 3/21/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *taskTextField;
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property NSMutableArray *tasks;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasks = [NSMutableArray arrayWithObjects:@"task1", @"task2", @"task3", nil];
}


//updates cell with string from text field, sets background color to clear and text color to black
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.taskTextField.text];
    cell.textLabel.text = [self.tasks objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


//returns number of tasks in array
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}


//adds new task to table view, clears text field, and dismisses keyboard
- (IBAction)onAddButtonTapped:(UIButton *)sender {
    [self.tasks addObject:self.taskTextField.text];
    [self.taskTableView reloadData];
    self.taskTextField.text = nil;
    [[self view] endEditing:YES];
}


//changes cell text color to green once tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
}

//toggles edit and done buttons, allows user to delete and move tasks
- (IBAction)onEditButtonTapped:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Edit"] ) {
        [sender setTitle:@"Done"];
    } else {
        [sender setTitle:@"Edit"];
    }
    [self.taskTableView setEditing:!self.taskTableView.editing animated:YES];
    NSLog(@"%i", self.taskTableView.editing);
}


//method to delete row from table view with confirmation alert
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deleteTask = [UIAlertAction actionWithTitle:@"Delete"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
            [self.tasks removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        [alertController addAction:deleteTask];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


//adds swipe gesture changing cell color on right swipe
- (IBAction)onRightSwipe:(UISwipeGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.taskTableView];
    NSIndexPath *indexPath = [self.taskTableView indexPathForRowAtPoint:location];
    UITableViewCell *cell = [self.taskTableView cellForRowAtIndexPath:indexPath];
    if (cell.backgroundColor == [UIColor clearColor]) {
        cell.backgroundColor = [UIColor greenColor];
    } else if (cell.backgroundColor == [UIColor greenColor]) {
        cell.backgroundColor = [UIColor yellowColor];
    } else if (cell.backgroundColor == [UIColor yellowColor]) {
        cell.backgroundColor = [UIColor redColor];
    } else if (cell.backgroundColor == [UIColor redColor]) {
        cell.backgroundColor = [UIColor clearColor];
    }
}


//method to reorder array
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = [self.tasks objectAtIndex:sourceIndexPath.row];
    [self.tasks removeObjectAtIndex:sourceIndexPath.row];
    [self.tasks insertObject:stringToMove atIndex:destinationIndexPath.row];
}


@end
