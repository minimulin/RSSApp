//
//  CSlViewController.h
//  RSSApp
//
//  Created by mrStiher on 28.07.13.
//  Copyright (c) 2013 mrStiher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSlMainListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
