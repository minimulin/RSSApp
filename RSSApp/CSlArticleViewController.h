//
//  CSlArticleViewCOntrollerViewController.h
//  RSSApp
//
//  Created by mrStiher on 30.07.13.
//  Copyright (c) 2013 mrStiher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface CSlArticleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) Article *article;
@property (weak, nonatomic) IBOutlet UILabel *pubDate;
@property (weak, nonatomic) IBOutlet UITextView *articleAnounce;
@property (weak, nonatomic) IBOutlet UIButton *favoriteImage;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIButton *linkImage;
-(NSString *) stringByStrippingHTML:(NSString *)htmlStr;
@end
