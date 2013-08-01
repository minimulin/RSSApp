//
//  CSlArticleViewCOntrollerViewController.m
//  RSSApp
//
//  Created by Ренара on 30.07.13.
//  Copyright (c) 2013 Ренара. All rights reserved.
//

#import "CSlArticleViewController.h"

@interface CSlArticleViewController ()

@end

@implementation CSlArticleViewController
@synthesize mainLabel, article, pubDate, articleAnounce;

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
    
    self.mainLabel.text = self.article.title;
    self.pubDate.text = self.article.pubDate;
    self.articleAnounce.text = [self stringByStrippingHTML:[self.article.articleAnounce stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"]];
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
