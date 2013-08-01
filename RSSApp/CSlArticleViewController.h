//
//  CSlArticleViewCOntrollerViewController.h
//  RSSApp
//
//  Created by Ренара on 30.07.13.
//  Copyright (c) 2013 Ренара. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSlArticle.h"

@interface CSlArticleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) CSlArticle *article;
@property (weak, nonatomic) IBOutlet UILabel *pubDate;
@property (weak, nonatomic) IBOutlet UITextView *articleAnounce;
-(NSString *) stringByStrippingHTML:(NSString *)htmlStr;
@end
