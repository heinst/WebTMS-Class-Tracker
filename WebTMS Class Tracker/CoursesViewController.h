//
//  CoursesViewController.h
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 10/18/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "ViewController.h"

@interface CoursesViewController : ViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *courseTable;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *course;
@property (strong, nonatomic) NSString *courseNum;
@property (strong, nonatomic) NSString *courseType;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSMutableArray *courseNames;
@property (strong, nonatomic) NSMutableArray *urls;
@end
