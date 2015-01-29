//
//  SectionsViewController.h
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 10/29/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "ViewController.h"

@interface SectionsViewController : ViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *sectionsTable;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *section;
@property (strong, nonatomic) NSString *course;
@property (strong, nonatomic) NSString *courseNum;
@property (strong, nonatomic) NSString *courseType;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *times;
@property (strong, nonatomic) NSMutableArray *urls;
@property (strong, nonatomic) NSMutableArray *classStatus;
@end
