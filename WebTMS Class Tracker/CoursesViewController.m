//
//  CoursesViewController.m
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 10/18/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "CoursesViewController.h"
#import <HTMLReader/HTMLReader.h>

@interface CoursesViewController ()

@end

@implementation CoursesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.courseTable setDelegate:self];
    [self.courseTable setDataSource:self];
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSLog(@"%@", self.url);
    NSString *webData= [NSString stringWithContentsOfURL:url];
    
    HTMLDocument *document = [HTMLDocument documentWithString:webData];
    
    NSArray *nodes = [document nodesMatchingSelector:@"tr"];
    self.courseNames = [[NSMutableArray alloc]init];
    self.urls = [[NSMutableArray alloc] init];
    NSString *baseUrl = @"https://duapp2.drexel.edu";
    
    for (int i = 0; i < [nodes count]; i++)
    {
        HTMLDocument *tempDoc = [nodes objectAtIndex:i];
        HTMLElement *tempElem = [tempDoc firstNodeMatchingSelector:@"tr"];
        
        
        if (([[tempElem objectForKeyedSubscript:@"class"]  isEqual:@"even"] || [[tempElem objectForKeyedSubscript:@"class"]  isEqual:@"odd"]))
        {
            
            NSArray *tdNodes = [tempDoc nodesMatchingSelector:@"td"];
            for (int j = 0; j < [tdNodes count]; j++)
            {
                HTMLDocument *tempDoc2 = [tdNodes objectAtIndex:j];
                NSString *collegeNameStripped = [tempDoc2.textContent stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                HTMLElement *aElem = [tempDoc2 firstNodeMatchingSelector:@"a"];
                NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, [aElem objectForKeyedSubscript:@"href"]];
                
                [self.courseNames addObject:collegeNameStripped];
                [self.urls addObject:url];
            }
        }
        
    }
    
    [self.courseTable reloadData];
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
    return [self.courseNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.courseNames objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.url = [self.urls objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"coursesStoryboard" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"coursesStoryboard"])
    {
        CoursesViewController  *coursesViewController = segue.destinationViewController;
        coursesViewController.url = self.url;
    }
    
}

@end
