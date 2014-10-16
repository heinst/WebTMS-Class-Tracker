//
//  ClassViewController.h
//  WebTMS Class Tracker
//
//  Created by Trevor Heins on 10/15/14.
//  Copyright (c) 2014 Trevor Heins. All rights reserved.
//

#import "ViewController.h"

@interface ClassViewController : ViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *termNames;
@property (strong, nonatomic) IBOutlet UITableView *termsTable;

@end
