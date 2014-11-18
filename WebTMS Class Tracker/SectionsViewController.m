//
//  SectionsViewController.m
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 10/29/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "SectionsViewController.h"
#import <HTMLReader/HTMLReader.h>
#import "ClassInfoViewController.h"

@interface SectionsViewController ()

@end

@implementation SectionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.sectionsTable setDelegate:self];
    [self.sectionsTable setDataSource:self];
    self.title = @"Sections";
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSError *error = nil;
    NSString *webData= [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    HTMLDocument *document = [HTMLDocument documentWithString:webData];
    
    NSArray *nodes = [document nodesMatchingSelector:@"tr"];
    self.sections = [[NSMutableArray alloc]init];
    self.times = [[NSMutableArray alloc]init];
    self.urls = [[NSMutableArray alloc] init];
    self.classStatus = [[NSMutableArray alloc] init];
    NSString *baseUrl = @"https://duapp2.drexel.edu";
    
    
    for (int i = 0; i < [nodes count]; i++)
    {
        HTMLDocument *tempDoc = [nodes objectAtIndex:i];
        HTMLElement *tempElem = [tempDoc firstNodeMatchingSelector:@"tr"];
        
        if (([[tempElem objectForKeyedSubscript:@"class"]  isEqual:@"even"] || [[tempElem objectForKeyedSubscript:@"class"]  isEqual:@"odd"]))
        {
            
            NSArray *tdNodes = [tempDoc nodesMatchingSelector:@"td"];
            NSString *courseName;
            NSString *courseNum;
            NSString *courseType;
            NSString *courseSection;
            HTMLDocument *tempDoc2;
            //NSString *
            for (int j = 0; j < [tdNodes count]; j++)
            {
                tempDoc2 = [tdNodes objectAtIndex:j];
                if (j == 0)
                {
                    courseName = [tempDoc2.textContent stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                }
                else if (j == 1)
                {
                    courseNum = [tempDoc2.textContent stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                }
                else if (j == 2)
                {
                    courseType = [tempDoc2.textContent stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                }
                else if(j == 4)
                {
                    courseSection = [tempDoc2.textContent stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                }
                
            }
            NSString * courseNameNum = [NSString stringWithFormat:@"%@ %@", courseName, courseNum];
            if ([courseNameNum isEqualToString:self.section])
            {
                 NSString * courseNameNumType = [NSString stringWithFormat:@"%@ %@ %@", courseNameNum, courseType, courseSection];
                [self.sections addObject:courseNameNumType];
                HTMLElement *aElem = [tempDoc firstNodeMatchingSelector:@"a"];
                NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, [aElem objectForKeyedSubscript:@"href"]];
                HTMLElement *pElem = [tempDoc firstNodeMatchingSelector:@"p"];
                NSString *status = [NSString stringWithFormat:@"%@", [pElem objectForKeyedSubscript:@"title"]];
                
                tempDoc = [nodes objectAtIndex:i + 1];
                tempElem = [tempDoc firstNodeMatchingSelector:@"tr"];
                tdNodes = [tempDoc nodesMatchingSelector:@"td"];
                tempDoc2 = [tdNodes objectAtIndex:0];
                NSString *day = [tempDoc2.textContent stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                tempDoc2 = [tdNodes objectAtIndex:1];
                NSString *time = [tempDoc2.textContent stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                NSString *dayTime = [NSString stringWithFormat:@"%@ %@", day, time];
                [self.urls addObject:url];
                [self.classStatus addObject:status];
                [self.times addObject:dayTime];
                
                
                
            }
        }
        
    }
    [self.sectionsTable reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.sections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
    }
    
    cell.textLabel.text = [self.sections objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = [self.times objectAtIndex:indexPath.row];
    
    NSString *status = [self.classStatus objectAtIndex:indexPath.row];
    
    if(([status isEqualToString:@"FULL"]))
    {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    else
    {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.url = [self.urls objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"classInfoStoryboard" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"classInfoStoryboard"])
    {
        ClassInfoViewController *classInfoViewController = segue.destinationViewController;
        classInfoViewController.url = self.url;
        
    }
    
}
@end
