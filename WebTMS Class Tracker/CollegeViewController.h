//
//  CollegeViewController.h
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 10/16/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "ViewController.h"

@interface CollegeViewController : ViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *collegeTable;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSMutableArray *collegeNames;
@property (strong, nonatomic) NSMutableArray *urls;
@end
