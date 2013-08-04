//
//  Article.h
//  RSSApp
//
//  Created by Ренара on 04.08.13.
//  Copyright (c) 2013 Ренара. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Article : NSManagedObject

@property (nonatomic, retain) NSString * anounce;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * link;

@end
