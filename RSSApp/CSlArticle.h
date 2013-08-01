//
//  CSlArticle.h
//  RSSApp
//
//  Created by Ренара on 29.07.13.
//  Copyright (c) 2013 Ренара. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSlArticle : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, copy) NSString *articleAnounce;
@property (nonatomic) BOOL *isFavorite;
@property (nonatomic) BOOL *hasBeenRead;

-(void) initWithData:(NSString *) articleTitle:(NSString *) pubDate:(NSString *) articleAnounce;

@end
