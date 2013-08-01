//
//  CSlArticle.m
//  RSSApp
//
//  Created by Ренара on 29.07.13.
//  Copyright (c) 2013 Ренара. All rights reserved.
//

#import "CSlArticle.h"

@implementation CSlArticle

-(void) initWithData:(NSString *) articleTitle:(NSString *) pubDate:(NSString *) articleAnounce {
    self.title = articleTitle;
    self.pubDate = pubDate;
    self.articleAnounce = articleAnounce;
}

@end
