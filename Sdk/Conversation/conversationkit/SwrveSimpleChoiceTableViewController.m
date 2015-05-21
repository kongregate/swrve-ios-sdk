#if !__has_feature(objc_arc)
#error ConverserSDK must be built with ARC.
// You can turn on ARC for only ConverserSDK files by adding -fobjc-arc to the build phase for each of its files.
#endif

#import "SwrveConversationResource.h"
#import "SwrveSimpleChoiceTableViewController.h"
#import "SwrveSetup.h"
#import "SwrveConversationStyler.h"

@interface SwrveSimpleChoiceTableViewController () {
    NSIndexPath *refreshIndex;
}
@end

@implementation SwrveSimpleChoiceTableViewController
@synthesize choiceValues = _choiceValues;
@synthesize pageStyle, choiceStyle;

-(void) viewWillAppear:(BOOL)animated {
#pragma unused (animated)
    self.title = self.choiceValues.title;
    if(refreshIndex) {
        [(UITableView *)self.view reloadRowsAtIndexPaths:[NSArray arrayWithObject:refreshIndex] withRowAnimation:UITableViewRowAnimationNone];
        refreshIndex = nil;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SwrveConversationStyler styleView:self.view withStyle:self.pageStyle];
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#pragma unused (tableView)
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#pragma unused (tableView, section)
    return (NSInteger)self.choiceValues.choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString *CellIdentifier = @"SwrveSimpleChoiceCell";
    static NSString *CellIdentifierMore = @"SwrveSimpleChoiceMoreCell";
    if(self.choiceValues.hasMore) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierMore];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifierMore];
        }
        SwrveChoiceArray *inner = [self.choiceValues.choices objectAtIndex:(NSUInteger)indexPath.row];
        cell.textLabel.text = inner.title;
        cell.detailTextLabel.text = inner.selectedItem;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *chosenElement = [self.choiceValues.choices objectAtIndex:(NSUInteger)indexPath.row];
        cell.textLabel.text = [chosenElement objectForKey:@"answer_text"];
        if(indexPath.row == self.choiceValues.selectedIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    [SwrveConversationStyler styleView:cell withStyle:self.choiceStyle];
    return cell;
}

@end
