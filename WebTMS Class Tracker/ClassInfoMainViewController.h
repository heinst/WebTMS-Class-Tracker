//
//  ClassInfoMainViewController.h
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 11/4/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "ViewController.h"

@interface ClassInfoMainViewController : ViewController

@property (weak, nonatomic) IBOutlet UILabel *crn;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *classCredits;
@property (weak, nonatomic) IBOutlet UILabel *section;
@property (weak, nonatomic) IBOutlet UILabel *classTitle;
@property (weak, nonatomic) IBOutlet UILabel *campus;
@property (weak, nonatomic) IBOutlet UILabel *classInstructors;
@property (weak, nonatomic) IBOutlet UILabel *instructionType;
@property (weak, nonatomic) IBOutlet UILabel *classEnrollment;
@property (weak, nonatomic) IBOutlet UILabel *classComments;
@property (weak, nonatomic) IBOutlet UILabel *classTime;
@property (weak, nonatomic) IBOutlet UILabel *finalTime;

@property (strong, nonatomic) NSMutableArray *classesArray;

@property (strong, nonatomic) NSString *url;

@end
