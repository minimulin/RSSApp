#import "CSlMainListViewController.h"
#import "CSlArticleViewController.h"
#import "Article.h"
#import "CSlAppDelegate.h"
#import "Reachability.h"

@interface CSlMainListViewController ()
@property (nonatomic, strong) NSString *currentKey;
@property (nonatomic, strong) NSMutableString *currentStringValue;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) Article *article;
@end

@implementation CSlMainListViewController

@synthesize currentKey = _currentKey;
@synthesize currentStringValue = _currentStringValue;
@synthesize tableData = _tableData;
@synthesize article = _article;
@synthesize managedObjectContext = _managedObjectContext;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [self.currentStringValue setString:@""];
    if ([elementName isEqualToString:@"item"]) {
        self.currentKey = elementName;
        self.article = [[Article alloc] initWithEntity:[NSEntityDescription entityForName:@"Article" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:nil];
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
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^#([0-9]{5,}):" options:NSRegularExpressionCaseInsensitive error:nil];
            NSString *cleanTitle = [regex stringByReplacingMatchesInString:self.currentStringValue options:0 range:NSMakeRange(0, self.currentStringValue.length) withTemplate:@""];
            [self.article setName:cleanTitle];
            NSTextCheckingResult *result = [regex firstMatchInString:self.currentStringValue options:0 range:NSMakeRange(0, self.currentStringValue.length)];
            [self.article setIndex:[[NSNumber alloc]initWithInt:[[self.currentStringValue substringWithRange:[result rangeAtIndex:1]] intValue]]];
        }
        
        if ([elementName isEqualToString:@"pubDate"]) {
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
            NSDate *pubDate = [inputFormatter dateFromString:self.currentStringValue];
            [self.article setPubDate:pubDate];
        }
        
        if ([elementName isEqualToString:@"description"]) {
            [self.article setAnounce:self.currentStringValue];
        }
        
        if ([elementName isEqualToString:@"link"]) {
            [self.article setLink:self.currentStringValue];
        }
        
        if ([elementName isEqualToString:@"item"]) {
            [self.article setIsRead:NO];
            [self.article setIsFavorite:NO];
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Article"
                                           inManagedObjectContext:self.managedObjectContext]];
            
            [request setPredicate:[NSPredicate predicateWithFormat:@"(index = %@)",self.article.index]];
            NSError * error = nil;
            NSArray * objects = [self.managedObjectContext executeFetchRequest:request error:&error];
            
            if (error) {
                NSLog(@"Ошибка при исполнении запроса");
            } else {
                if ([objects count]==0) {
                    [self.managedObjectContext insertObject:self.article];
                } else {
                    
                }
            }
            
            error = nil;
            if (self.managedObjectContext != nil) {
                if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CSlAppDelegate *appDelegate = (CSlAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    //Раскомментировать для удаления всех статей в БД
//    NSFetchRequest * request2;
//    request2 = [[NSFetchRequest alloc] init];
//    [request2 setEntity:[NSEntityDescription entityForName:@"Article"
//                                    inManagedObjectContext:self.managedObjectContext]];
//    NSError * error2 = nil;
//    NSArray * objects2 = [self.managedObjectContext executeFetchRequest:request2 error:&error2];
//    NSLog(@"Статей в базе до запроса: %i",[objects2 count]);
//    
//    for (Article * currentArticle in objects2) {
//        [self.managedObjectContext deleteObject:currentArticle];
//        
//    }
//    [self.managedObjectContext save:&error2];
    
    self.title = @"Список статей";
    
    self.tableView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"http://ithappens.ru/rss"];
    
    NSXMLParser *xmlParser2 = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlParser2 setDelegate:self];
	BOOL success = [xmlParser2 parse];
    if (!success) {
        NSLog(@"Что-то произошло и XML'ка оказалась плохой");
    } else {
        [self updateTableView];
    }
    
    self.tabBar.delegate = self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *articleNameLabel = (UILabel *)[cell viewWithTag:1];
    articleNameLabel.text = [[self.tableData objectAtIndex:indexPath.row] name];
    if (![[self.tableData objectAtIndex:indexPath.row] isRead]) {
        [articleNameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    } else {
        [articleNameLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    }
    
    
    UILabel *pubDate = (UILabel *)[cell viewWithTag:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU_POSIX"]];
    [dateFormatter setDateFormat:@"d MMMM"];
    pubDate.text = [dateFormatter stringFromDate:[[self.tableData objectAtIndex:indexPath.row] pubDate]];

    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteImageHandler:)];
    tapped.numberOfTapsRequired = 1;
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:4];
    if ([[[self.tableData objectAtIndex:indexPath.row] isFavorite] isEqualToNumber:[[NSNumber alloc] initWithInt:1]]) {
        imageView.alpha = 1;
    } else {
        imageView.alpha = 0.2;
    }
    [imageView addGestureRecognizer:tapped];
    UILabel *indexLabel = (UILabel*)[cell.contentView viewWithTag:5];
    indexLabel.text = [[[self.tableData objectAtIndex:indexPath.row] index] stringValue];
    
    return cell;
}

-(void)favoriteImageHandler :(id) sender {
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    UITableViewCell *cell = (UITableViewCell*)gesture.view.superview;
    UILabel *indexLabel = (UILabel*)[cell viewWithTag:5];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Article"
                                   inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(index = %@)",indexLabel.text]];
    NSError * error = nil;
    NSArray * objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"With id=%@ = %i",indexLabel.text,[objects count]);
    if (error) {
        NSLog(@"Ошибка при исполнении запроса");
    } else {
        //TODO: Fix this bug
        if ([objects count]>0) {
            Article *article = (Article*)[objects objectAtIndex:0];
            if ([article.isFavorite isEqualToNumber:[[NSNumber alloc] initWithInt:1]]) {
                [article setIsFavorite:[[NSNumber alloc] initWithInt:0]];
                gesture.view.alpha = 0.2;
            } else {
                [article setIsFavorite:[[NSNumber alloc] initWithInt:1]];
                gesture.view.alpha = 1;
            }
            error = nil;
            [self.managedObjectContext save:&error];
        }
        [self updateTableView];
    }
}

- (void) viewWillAppear:(BOOL)animated {    
    [self updateTableView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewArticle"]) {
        CSlArticleViewController *articleView = [segue destinationViewController];
        articleView.article = [self.tableData objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        [articleView.article setIsRead:[[NSNumber alloc] initWithInt:1]];
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        [self.tableData replaceObjectAtIndex:[[self.tableView indexPathForSelectedRow] row] withObject:articleView.article];
    }
}

-(void) updateTableView {
    NSFetchRequest * request;
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Article"
                                   inManagedObjectContext:self.managedObjectContext]];
    [request setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"index" ascending:NO]]];
    NSError * error = nil;
    NSArray * objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    //Инициализация массива статей для TableView
    self.tableData = [[NSMutableArray alloc] initWithArray:objects];
    
    [self.tableView reloadData];
}
@end
