//
//  MainViewController.h
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 11/4/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "ViewController.h"

@interface MainViewController : ViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) NSMutableArray *classesArray;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *times;
@property (strong, nonatomic) NSMutableArray *classStatus;
@property (strong, nonatomic) NSString *section;
@property (strong, nonatomic) NSString *url;
- (IBAction)editClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end
