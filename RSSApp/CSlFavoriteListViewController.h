//
//  CSlFavoriteViewController.h
//  RSSApp
//
//  Created by Ренара on 04.08.13.
//  Copyright (c) 2013 Ренара. All rights reserved.
//

#import "CSlMainListViewController.h"

@interface CSlFavoriteListViewController : CSlMainListViewController <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UITabBarControllerDelegate>

-(void) updateTableView;

@end
