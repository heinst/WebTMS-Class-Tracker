//
//  CollegeViewController.m
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 10/16/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "CollegeViewController.h"
#import <HTMLReader/HTMLReader.h>
#import "SubjectsViewController.h"

@interface CollegeViewController ()

@end

@implementation CollegeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height - 64;
    
    self.collegeTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 64.0, screenWidth, screenHeight) style:UITableViewStylePlain];
    
    [self.collegeTable setDelegate:self];
    [self.collegeTable setDataSource:self];
    
    [self.view addSubview:self.collegeTable];
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSError *error = nil;
    NSString *webData= [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    HTMLDocument *document = [HTMLDocument documentWithString:webData];
    
    NSArray *nodes = [document nodesMatchingSelector:@"div"];
    self.collegeNames = [[NSMutableArray alloc]init];
    self.urls = [[NSMutableArray alloc] init];
    NSString *baseUrl = @"https://duapp2.drexel.edu";
    
    for (int i = 0; i < [nodes count]; i++)
    {
        HTMLDocument *tempDoc = [nodes objectAtIndex:i];
        HTMLElement *tempElem = [tempDoc firstNodeMatchingSelector:@"div"];
        
        
        if ([[tempElem objectForKeyedSubscript:@"id"]  isEqual:@"sideLeft"])
        {
            
            NSArray *aNodes = [tempDoc nodesMatchingSelector:@"a"];
            for (int j = 0; j < [aNodes count]; j++)
            {
                HTMLDocument *tempDoc2 = [aNodes objectAtIndex:j];
                NSString *collegeNameStripped = [tempDoc2.textContent stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                HTMLElement *aElem = [tempDoc2 firstNodeMatchingSelector:@"a"];
                NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, [aElem objectForKeyedSubscript:@"href"]];
            
                [self.collegeNames addObject:collegeNameStripped];
                [self.urls addObject:url];
            }
        }
    }
    
    [self.collegeTable reloadData];
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
    return [self.collegeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.collegeNames objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.url = [self.urls objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"subjectStoryboard" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"subjectStoryboard"])
    {
        SubjectsViewController  *subjectViewController = segue.destinationViewController;
        subjectViewController.url = self.url;
    }
    
}

@end
