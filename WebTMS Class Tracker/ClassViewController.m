//
//  ClassViewController.m
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 10/15/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "ClassViewController.h"
#import "CollegeViewController.h"
#import <HTMLReader/HTMLReader.h>

@interface ClassViewController ()

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.termsTable setDelegate:self];
    [self.termsTable setDataSource:self];
    
    NSURL *url = [NSURL URLWithString:@"https://duapp2.drexel.edu/webtms_du/app"];
    NSString *webData= [NSString stringWithContentsOfURL:url];
    
    HTMLDocument *document = [HTMLDocument documentWithString:webData];
    
    NSArray *nodes = [document nodesMatchingSelector:@"div"];
    self.termNames = [[NSMutableArray alloc]init];
    self.urls = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [nodes count]; i++)
    {
        HTMLDocument *tempDoc = [nodes objectAtIndex:i];
        
        if (([tempDoc.textContent containsString:@"Semester"]) || ([tempDoc.textContent containsString:@"Quarter"]))
        {
            NSString *baseUrl = @"https://duapp2.drexel.edu";
            NSString *termNameStripped = [tempDoc.textContent stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
            HTMLElement *aElem = [tempDoc firstNodeMatchingSelector:@"a"];
            NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, [aElem objectForKeyedSubscript:@"href"]];
            
            [self.termNames addObject:termNameStripped];
            [self.urls addObject:url];
        }
    }
    
    [self.termsTable reloadData];
    
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
    return [self.termNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.termNames objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.url = [self.urls objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"TermStoryboard" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CollegeStoryboard"])
    {
        CollegeViewController *collegeViewController = segue.destinationViewController;
        collegeViewController.url = self.url;
    }
}

@end
