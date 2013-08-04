//
//  CSlTabBarController.m
//  RSSApp
//
//  Created by Ренара on 05.08.13.
//  Copyright (c) 2013 Ренара. All rights reserved.
//

#import "CSlTabBarController.h"

@interface CSlTabBarController ()

@end

@implementation CSlTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //TODO: pop all views due click on tab bar item
    [self.navigationController popViewControllerAnimated:YES];
}

@end
