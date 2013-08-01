//
//  CSlViewController.m
//  RSSApp
//
//  Created by Ренара on 28.07.13.
//  Copyright (c) 2013 Ренара. All rights reserved.
//

#import "CSlViewController.h"
#import "CSlArticleViewController.h"
#import "CSlArticle.h"

@interface CSlViewController ()
@property (nonatomic, strong) NSString *currentKey;
@property (nonatomic, strong) NSMutableString *currentStringValue;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) CSlArticle *article;

@end

@implementation CSlViewController

@synthesize currentKey = _currentKey;
@synthesize currentStringValue = _currentStringValue;
@synthesize tableData = _tableData;
@synthesize article = _article;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    [self.currentStringValue setString:@""];
    if ([elementName isEqualToString:@"item"]) {
        self.currentKey = elementName;
        self.article = [CSlArticle alloc];
        [self.article initWithData:@"" :@"":@""];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([self.currentStringValue length]==0) {
        self.currentStringValue = [[NSMutableString alloc] initWithCapacity:200];
    }
    [self.currentStringValue appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([self.currentKey isEqualToString:@"item"]) {
        if ([elementName isEqualToString:@"title"]) {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^#[0-9]{5,}:"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            NSString *cleanTitle = [regex stringByReplacingMatchesInString:self.currentStringValue options:0 range:NSMakeRange(0, self.currentStringValue.length) withTemplate:@""];
            self.article.title = cleanTitle;
        }
        
        if ([elementName isEqualToString:@"pubDate"]) {
            self.article.pubDate = self.currentStringValue;
        }
        
        if ([elementName isEqualToString:@"description"]) {
            self.article.articleAnounce = self.currentStringValue;
        }
        
        if ([elementName isEqualToString:@"item"]) {
            [self.tableData addObject:self.article];
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Список статей";
    
    NSURL *url = [NSURL URLWithString:@"http://ithappens.ru/rss"];
    
    //Инициализация массива статей для TableView
    self.tableData = [[NSMutableArray alloc] init];
    
    NSXMLParser *xmlParser2 = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlParser2 setDelegate:self];
	BOOL success = [xmlParser2 parse];
    if (!success) {
        NSLog(@"Что-то произошло и XML'ка оказалась плохой");
    }
    
	[self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    NSLog(@"viewdidload");
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = [[self.tableData objectAtIndex:indexPath.row] title];
    
    UILabel *pubDate = (UILabel *)[cell viewWithTag:2];
    pubDate.text = [[self.tableData objectAtIndex:indexPath.row] pubDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewArticle"]) {
        CSlArticleViewController *articleView = [segue destinationViewController];
        articleView.article = [self.tableData objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    }
}
@end
