//
//  CSlArticleViewCOntrollerViewController.m
//  RSSApp
//
//  Created by mrStiher on 30.07.13.
//  Copyright (c) 2013 mrStiher. All rights reserved.
//

#import "CSlArticleViewController.h"
#include "Reachability.h"
#include "CSlAppDelegate.h"

@interface CSlArticleViewController ()

@end

@implementation CSlArticleViewController
@synthesize mainLabel, article, pubDate, articleAnounce;
@synthesize managedObjectContext = _managedObjectContext;

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
    
    CSlAppDelegate *appDelegate = (CSlAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    self.mainLabel.text = self.article.name;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU_POSIX"]];
    [dateFormatter setDateFormat:@"d MMMM"];
    self.pubDate.text = [dateFormatter stringFromDate:self.article.pubDate];
    self.articleAnounce.text = [self stringByStrippingHTML:[self.article.anounce stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"]];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteImageDetailHandler:)];
    tapped.numberOfTapsRequired = 1;
    [self.favoriteImage addGestureRecognizer:tapped];
    
    UITapGestureRecognizer *goToLink = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLinkHandler:)];
    goToLink.numberOfTapsRequired = 1;
    [self.linkImage addGestureRecognizer:goToLink];
}

-(void)goToLinkHandler :(id) sender {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if (![reachability currentReachabilityStatus] != NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Подключение" message:@"Отсутствует подключение к сети Интернет" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]; [alert show];
    } else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://ithappens.ru/story/", self.article.index]];
        if (![[UIApplication sharedApplication] openURL:url])
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    if ([self.article.isFavorite isEqualToNumber:[[NSNumber alloc] initWithInt:1]]) {
        self.favoriteImage.alpha = 1;
    } else {
        self.favoriteImage.alpha = 0.2;
    }

}

-(void)favoriteImageDetailHandler :(id) sender {
    if ([self.article.isFavorite isEqualToNumber:[[NSNumber alloc] initWithInt:1]]) {
        [self.article setIsFavorite:[[NSNumber alloc] initWithInt:0]];
        self.favoriteImage.alpha = 0.2;
    } else {
        [self.article setIsFavorite:[[NSNumber alloc] initWithInt:1]];
        self.favoriteImage.alpha = 1;
    }
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Article"
                                   inManagedObjectContext:self.managedObjectContext]];
    [request setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"index" ascending:NO]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(isFavorite = 1)"]];
    error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([objects count]>0) {
        [[[self.tabBarController.tabBar items] objectAtIndex:1] setEnabled:YES];
    } else {
        [[[self.tabBarController.tabBar items] objectAtIndex:1] setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) stringByStrippingHTML:(NSString *)htmlStr
{
    NSRange r;
    while ((r = [htmlStr rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        htmlStr = [htmlStr stringByReplacingCharactersInRange:r withString:@""];
    htmlStr=[htmlStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\n"];
    return htmlStr;
}

@end
