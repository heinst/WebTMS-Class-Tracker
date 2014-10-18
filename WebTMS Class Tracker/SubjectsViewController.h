//
//  SubjectsViewController.h
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 10/18/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "ViewController.h"

@interface SubjectsViewController : ViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *subjectTable;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSMutableArray *subjectNames;
@property (strong, nonatomic) NSMutableArray *urls;
@end
