//
//  MainTableViewController.m
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 11/4/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "MainTableViewController.h"
#import <HTMLReader/HTMLReader.h>
#import "ClassInfoMainViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    NSURL *url = [NSURL URLWithString:@"https://duapp2.drexel.edu/webtms_du/app"];
    NSError *error = nil;
    NSString *webData= [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    if ((!([webData rangeOfString:@"System Maintenance"].location == NSNotFound)) || webData == nil)
    {
        [self.addButton setEnabled:NO];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"WebTMS is Down"
                                                          message:@"WebTMS seems to be down. Please try again later."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }
    
    [self loadData];
    
    [self.tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self loadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadData];
    if (!([[self.classesArray objectAtIndex:0] isEqualToString:@"Add some favorites!"]))
    {
        self.editButton.enabled = YES;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.classesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
    }
    
    if (([[self.classesArray objectAtIndex:0] isEqualToString:@"Add some favorites!"]))
    {
        cell.textLabel.text = [self.classesArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
        cell.accessoryType = NO;
        cell.userInteractionEnabled = NO;
    }
    else
    {

        
        cell.userInteractionEnabled = YES;
        
        cell.textLabel.text = [self.sections objectAtIndex:indexPath.row];
        
        cell.detailTextLabel.text = [self.times objectAtIndex:indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        NSString *status = [self.classStatus objectAtIndex:indexPath.row];
        
        
        if(([status isEqualToString:@"CLOSED"]))
        {
            cell.textLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        else
        {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
    }
   
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.url = [self.classesArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"infoStoryboard" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"infoStoryboard"])
    {
        ClassInfoMainViewController *classInfoMainViewController = segue.destinationViewController;
        classInfoMainViewController.url = self.url;
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (IBAction)editClicked:(id)sender
{
    if ([self.tableView isEditing])
    {
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [self.tableView setEditing:NO animated:YES];
        self.editButton.title = @"Edit";
    }
    else
    {
        self.editButton.title = @"Done";
        
        // Turn on edit mode
        
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the managedObjectContext from the AppDelegate (for use in CoreData Applications)
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        
        [self.classesArray removeObjectAtIndex:indexPath.row];
        
        
        [userDefaults setObject:self.classesArray forKey:@"classesArray"];
        [userDefaults synchronize];
        
        self.classesArray = [[userDefaults objectForKey:@"classesArray"] mutableCopy];

        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Additional code to configure the Edit Button, if any
        if (self.classesArray.count == 0)
        {
            self.editButton.enabled = NO;
            self.editButton.title = @"Edit";
            [self loadData];
        }
    }
}


-(void)loadData
{
    self.classesArray = [[NSMutableArray alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.classesArray = [[userDefaults objectForKey:@"classesArray"] mutableCopy];
    
    if ((self.classesArray == nil) || ([self.classesArray count] == 0))
    {
        self.classesArray = [[NSMutableArray alloc] init];
        [self.classesArray addObject:@"Add some favorites!"];
    }
    
    self.sections = [[NSMutableArray alloc]init];
    self.times = [[NSMutableArray alloc]init];
    self.classStatus = [[NSMutableArray alloc] init];
    NSMutableDictionary *sectionDict = [[NSMutableDictionary alloc] init];
    
    
    if (!([[self.classesArray objectAtIndex:0] isEqualToString:@"Add some favorites!"]))
    {
        for (int l = 0; l < [self.classesArray count]; l++)
        {
            bool tbdParsed;
            
            
            NSURL *url = [NSURL URLWithString:[self.classesArray objectAtIndex:l]];
            NSError *error = nil;
            NSString *webData= [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
            
            HTMLDocument *document = [HTMLDocument documentWithString:webData];
            
            NSArray *nodes = [document nodesMatchingSelector:@"td"];
            
            for (int i = 0; i < [nodes count]; i++)
            {
                tbdParsed = FALSE;
                HTMLDocument *tempDoc = [nodes objectAtIndex:i];
                HTMLElement *tempElem = [tempDoc firstNodeMatchingSelector:@"td"];
                
                
                if ([[tempElem objectForKeyedSubscript:@"align"]  isEqual:@"center"])
                {
                    
                    NSArray *trNodes = [tempDoc nodesMatchingSelector:@"tr"];
                    for (int j = 0; j < [trNodes count]; j++)
                    {
                        HTMLDocument *tempDoc2 = [trNodes objectAtIndex:j];
                        NSArray *tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                        HTMLElement *tempElem2 = [tdArray objectAtIndex:0];
                        NSString *line = tempElem2.textContent;
                        if (([line containsString:@"Subject Code"]))
                        {
                            tempElem2 = [tdArray objectAtIndex:1];
                            NSString *classSubj = tempElem2.textContent;
                            tempDoc2 = [trNodes objectAtIndex:j + 1];
                            tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                            tempElem2 = [tdArray objectAtIndex:1];
                            NSString *classCode = tempElem2.textContent;
                            NSString *classInfo = [NSString stringWithFormat:@"%@ %@", classSubj, classCode];
                            [sectionDict setObject:classInfo forKey:[self.classesArray objectAtIndex:l]];
                        }
                        else if (([line isEqualToString:@"Section"]))
                        {
                            tempElem2 = [tdArray objectAtIndex:1];
                            NSString *classSection = tempElem2.textContent;
                            NSString *classInfoSection = [NSString stringWithFormat:@"%@ %@", [sectionDict objectForKey:[self.classesArray objectAtIndex:l]], classSection];
                            [self.sections addObject:classInfoSection];
                        }
                        else if (([line isEqualToString:@"Max Enroll"]))
                        {
                            //tempElem2 = [tdArray objectAtIndex:1];
                            tempElem2 = [tdArray objectAtIndex:1];
                            //NSString *maxEnrollment = tempElem2.textContent;
                            tempDoc2 = [trNodes objectAtIndex:j + 1];
                            tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                            tempElem2 = [tdArray objectAtIndex:1];
                            NSString *currentEnrollment = tempElem2.textContent;
                            [self.classStatus addObject:currentEnrollment];
                        }
                        
                    }
                }
                else if (([[tempElem objectForKeyedSubscript:@"align"]  isEqual:@"center"]) || ([[tempElem objectForKeyedSubscript:@"align"]  isEqual:@"left"]))
                {
                    if (([tempElem.textContent containsString:@"am"]) || ([tempElem.textContent containsString:@"pm"]))
                    {
                        NSArray *tdNodes = [tempDoc nodesMatchingSelector:@"td"];
                        NSString *time;
                        NSString *day;
                        NSString *bldg;
                        NSString *room;
                        for (int k = 0; k < [tdNodes count]; k++)
                        {
                            HTMLDocument *tempDoc2 = [tdNodes objectAtIndex:k];
                            NSArray *tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                            HTMLElement *tempElem2 = [tdArray objectAtIndex:0];
                            NSString *line = tempElem2.textContent;
                            
                            
                            if ((([line containsString:@" am"]) || ([line containsString:@" pm"])) && (!([line containsString:@"Final"])))
                            {
                                if (!([line containsString:@"Days"]))
                                {
                                    time = line;
                                    
                                    tempDoc2 = [tdNodes objectAtIndex:k + 1];
                                    tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                                    tempElem2 = [tdArray objectAtIndex:0];
                                    day = tempElem2.textContent;
                                    
                                    tempDoc2 = [tdNodes objectAtIndex:k + 2];
                                    tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                                    tempElem2 = [tdArray objectAtIndex:0];
                                    bldg = tempElem2.textContent;
                                    
                                    tempDoc2 = [tdNodes objectAtIndex:k + 3];
                                    tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                                    tempElem2 = [tdArray objectAtIndex:0];
                                    room = tempElem2.textContent;
                                    
                                    NSString *classTime = [NSString stringWithFormat:@"%@ %@ %@ %@", time, day, bldg, room];
                                    [self.times addObject:classTime];
                                    
                                    
                                }
                            }
                            else if ([line containsString:@"TBD"])
                            {
                                if (!([line containsString:@"Days"]))
                                {
                                    if (!(tbdParsed))
                                    {
                                        time = line;
                                       
                                        [self.times addObject:time];
                                        tbdParsed = TRUE;
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    [self.tableView reloadData];
    
}
@end
