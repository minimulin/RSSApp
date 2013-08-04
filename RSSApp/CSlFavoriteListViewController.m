#import "CSlFavoriteListViewController.h"
#import "Article.h"
#import "CSlAppDelegate.h"

@interface CSlFavoriteListViewController ()
@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation CSlFavoriteListViewController

@synthesize tableData=_tableData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Избранное";
    
    self.tabBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) updateTableView {
    NSFetchRequest * request;
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Article"
                                   inManagedObjectContext:self.managedObjectContext]];
    [request setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"index" ascending:NO]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(isFavorite = 1)"]];
    NSError * error = nil;
    NSArray * objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    //Инициализация массива статей для TableView
    self.tableData = [[NSMutableArray alloc] initWithArray:objects];
    
    if ([objects count]>0) {
        
    } else {
        [self.tabBarController setSelectedIndex:0];
        [[[self.tabBarController.tabBar items] objectAtIndex:1] setEnabled:NO];
    }
    
    [self.tableView reloadData];
}


@end
