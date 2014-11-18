//
//  ClassInfoViewController.m
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 10/29/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "ClassInfoViewController.h"
#import <HTMLReader/HTMLReader.h>

@interface ClassInfoViewController ()

@end

@implementation ClassInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Course Info";
    NSURL *url = [NSURL URLWithString:self.url];
    NSError *error = nil;
    NSString *webData= [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    HTMLDocument *document = [HTMLDocument documentWithString:webData];
    
    NSArray *nodes = [document nodesMatchingSelector:@"td"];
    //self.termNames = [[NSMutableArray alloc]init];
    //self.urls = [[NSMutableArray alloc] init];
    //NSString *baseUrl = @"https://duapp2.drexel.edu";
    
    for (int i = 0; i < [nodes count]; i++)
    {
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
                if (([line containsString:@"CRN"]))
                {
                    tempElem2 = [tdArray objectAtIndex:1];
                    self.crn.text = tempElem2.textContent;
                }
                else if (([line containsString:@"Subject Code"]))
                {
                    tempElem2 = [tdArray objectAtIndex:1];
                    NSString *classSubj = tempElem2.textContent;
                    tempDoc2 = [trNodes objectAtIndex:j + 1];
                    tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                    tempElem2 = [tdArray objectAtIndex:1];
                    NSString *classCode = tempElem2.textContent;
                    self.className.text = [NSString stringWithFormat:@"%@ %@", classSubj, classCode];
                }
                else if (([line isEqualToString:@"Section"]))
                {
                    tempElem2 = [tdArray objectAtIndex:1];
                    self.section.text = tempElem2.textContent;
                }
                else if (([line isEqualToString:@"Credits"]))
                {
                    tempElem2 = [tdArray objectAtIndex:1];
                    NSString *credits = tempElem2.textContent;
                    credits = [credits stringByReplacingOccurrencesOfString:@" " withString:@""];
                    self.classCredits.text = tempElem2.textContent;
                }
                else if (([line isEqualToString:@"Title"]))
                {
                    tempElem2 = [tdArray objectAtIndex:1];
                    self.classTitle.text = tempElem2.textContent;
                }
                else if (([line isEqualToString:@"Campus"]))
                {
                    tempElem2 = [tdArray objectAtIndex:1];
                    self.campus.text = tempElem2.textContent;
                }
                else if (([line isEqualToString:@"Instructor(s)"]))
                {
                    tempElem2 = [tdArray objectAtIndex:1];
                    self.classInstructors.text = tempElem2.textContent;
                }
                else if (([line isEqualToString:@"Instruction Type"]))
                {
                    tempElem2 = [tdArray objectAtIndex:1];
                    self.instructionType.text = tempElem2.textContent;
                }
                else if (([line isEqualToString:@"Max Enroll"]))
                {
                    //tempElem2 = [tdArray objectAtIndex:1];
                    tempElem2 = [tdArray objectAtIndex:1];
                    NSString *maxEnrollment = tempElem2.textContent;
                    tempDoc2 = [trNodes objectAtIndex:j + 1];
                    tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                    tempElem2 = [tdArray objectAtIndex:1];
                    NSString *currentEnrollment = tempElem2.textContent;
                    self.classEnrollment.text = [NSString stringWithFormat:@"%@/%@", currentEnrollment, maxEnrollment];
                }
                else if (([line isEqualToString:@"Section Comments"]))
                {
                    tempElem2 = [tdArray objectAtIndex:1];
                    HTMLNode *tableNode = [tempElem2 childAtIndex:1];
                    NSArray *trArray = [tableNode nodesMatchingSelector:@"tr"];
                    tempDoc2 = [trArray objectAtIndex:0];
                    tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                    tempElem2 = [tdArray objectAtIndex:0];
                    self.classComments.text = tempElem2.textContent;
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
                
                NSString *fTime;
                NSString *finalDay;
                NSString *finalBldg;
                NSString *finalRoom;
                for (int k = 0; k < [tdNodes count]; k++)
                {
                    HTMLDocument *tempDoc2 = [tdNodes objectAtIndex:k];
                    NSArray *tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                    HTMLElement *tempElem2 = [tdArray objectAtIndex:0];
                    NSString *line = tempElem2.textContent;
                    
                    
                    if ((([line containsString:@" am"]) || ([line containsString:@" pm"])) && ([line containsString:@"Final"]))
                    {
                        if (!([line containsString:@"Days"]))
                        {
                            fTime = line;
                            
                            tempDoc2 = [tdNodes objectAtIndex:k + 1];
                            tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                            tempElem2 = [tdArray objectAtIndex:0];
                            finalDay = tempElem2.textContent;
                            
                            tempDoc2 = [tdNodes objectAtIndex:k + 2];
                            tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                            tempElem2 = [tdArray objectAtIndex:0];
                            finalBldg = tempElem2.textContent;
                            
                            tempDoc2 = [tdNodes objectAtIndex:k + 3];
                            tdArray = [tempDoc2 nodesMatchingSelector:@"td"];
                            tempElem2 = [tdArray objectAtIndex:0];
                            finalRoom = tempElem2.textContent;
                            
                            NSString *finalTime = [NSString stringWithFormat:@"%@ %@ %@ %@", fTime, finalDay, finalBldg, finalRoom];
                            self.finalTime.text = finalTime;
                            
                            
                        }
                        
                    }
                    else if (([line containsString:@" am"]) || (([line containsString:@" pm"])))
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
                            self.classTime.text = classTime;
                            
                            
                        }
                    }
                }
            }
        }
    }
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

- (IBAction)cancelButton:(id)sender
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)trackButton:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.classesArray = [[userDefaults objectForKey:@"classesArray"] mutableCopy];
    
    if(self.classesArray == nil)
    {
        self.classesArray = [[NSMutableArray alloc] init];
        [self.classesArray addObject:self.url];
    }
    else
    {
        [self.classesArray addObject:self.url];
    }
    
    [userDefaults setObject:self.classesArray forKey:@"classesArray"];
    [userDefaults synchronize];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Class Added to List" message:@"The class was added to your tracking list" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
