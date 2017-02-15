//
//  MasterViewController.m
//  SampleProject
//
//  Created by Omar Hagopian on 9/23/15.
//  Copyright © 2015 Clackmac. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface PhraseCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation PhraseCell

- (NSString *)reuseIdentifier {
    return @"Cell";
}

@end

@interface MasterViewController ()

@property NSMutableArray *phrases;
@property NSMutableArray *meanings;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.phrases = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Phrases" ofType:@"plist"]].mutableCopy;
    self.meanings = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Meanings" ofType:@"plist"]].mutableCopy;

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    self.tableView.estimatedRowHeight = 44;
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;

    [super viewWillAppear:animated];
}

- (void)insertNewObject:(id)sender {

}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.meanings[indexPath.row];

        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.phrases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhraseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.phrases[indexPath.row];
    cell.titleLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.phrases removeObjectAtIndex:indexPath.row];
        [self.meanings removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
