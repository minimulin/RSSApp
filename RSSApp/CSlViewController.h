//
//  CSlViewController.h
//  RSSApp
//
//  Created by Ренара on 28.07.13.
//  Copyright (c) 2013 Ренара. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSlViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
