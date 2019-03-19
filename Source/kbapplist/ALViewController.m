//
//  ViewController.m
//  ReordableUICollectionView
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//

#import "ALAppCell.h"
#import "ALHeaderView.h"
#import "ALResultsTableController.h"
#import "ALViewController.h"
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>

@interface UIImage (IndieDev)
+ (UIImage *)_applicationIconImageForBundleIdentifier:
                 (NSString *)bundleIdentifier
                                               format:(int)format
                                                scale:(CGFloat)scale;
@end

@interface ALViewController ()
@property(nonatomic, retain) UICollectionView *collectionView;
@property(nonatomic, retain) UISearchController *searchController;
@property(nonatomic, retain) ALResultsTableController *resultsTableController;
@property(nonatomic, assign) BOOL quickEdit;
@property(nonatomic, retain) UILongPressGestureRecognizer *longPress;
@end

@implementation ALViewController
int count;
NSMutableArray *selectedToMove;
NSMutableArray *unselectedToMove;
UIColor *highlightColor;
ALAppCell *movingCell;

- (void)viewWillAppear:(BOOL)arg1 {
    [super viewWillAppear:arg1];
    UICollectionViewFlowLayout *layout =
        [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((self.view.bounds.size.width - 20), 40);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 60);
    layout.sectionHeadersPinToVisibleBounds = YES;

    ////CollectionView
    self.collectionView = [[UICollectionView alloc]
               initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                        self.view.bounds.size.height)
        collectionViewLayout:layout];
    /*
       self.collectionView.autoresizingMask =
            (UIViewAutoresizingFlexibleWidth |
       UIViewAutoresizingFlexibleHeight);
    */
    self.collectionView.pagingEnabled = NO;
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    ////self.collectionView.contentSize=self.collectionView.bounds.size;
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.allowsSelection = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ALHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[ALAppCell class]
            forCellWithReuseIdentifier:@"CELL"];
    [self.collectionView registerClass:[ALTopCell class]
            forCellWithReuseIdentifier:@"TOPCELL"];
    [self.collectionView registerClass:[ALBottomCell class]
            forCellWithReuseIdentifier:@"BOTTOMCELL"];
    [self.collectionView registerClass:[ALHolderCell class]
            forCellWithReuseIdentifier:@"HOLDERCELL"];
    ///  [self.collectionView.collectionViewLayout collectionViewContentSize];
    ////Gestures
    self.longPress = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(handleLongPress:)];
    self.longPress.minimumPressDuration = 0.2;
    [self.collectionView addGestureRecognizer:self.longPress];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// self.view.bounds= UIScreen.mainScreen.bounds;
    self.view.backgroundColor = UIColor.whiteColor;
    highlightColor = [UIColor colorWithRed:54.0 / 255.0
                                     green:141.0 / 255.0
                                      blue:244.0 / 255.0
                                     alpha:1];

    ////SearchController
    self.resultsTableController = [ALResultsTableController new];
    self.searchController = [[UISearchController alloc]
        initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = false;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchController.searchBar.placeholder = @"App";
    self.searchController.searchBar.tintColor = UIColor.whiteColor;
    self.searchController.searchBar.barTintColor =
        [UIColor colorWithRed:53.0 / 255.0
                        green:59.0 / 255.0
                         blue:68.0 / 255.0
                        alpha:1.0];
    self.searchController.hidesNavigationBarDuringPresentation = true;
    self.searchController.searchBar.keyboardAppearance =
        UIKeyboardAppearanceDark;
    [[UITextField
        appearanceWhenContainedInInstancesOfClasses:@ [[UISearchBar class]]]
        setTintColor:UIColor.blackColor];
    self.searchController.view.backgroundColor =
        [UIColor colorWithRed:53 / 255.0
                        green:59 / 255.0
                         blue:68.0 / 255.0
                        alpha:0.75];
    self.definesPresentationContext = YES;

    ////Data for applist
    NSDictionary *properties = self.specifier.properties;

    self.navigationItem.title = properties[@"label"];
    self.preferencesSuiteName = properties[@"defaults"];
    self.preferencesKey = properties[@"key"];
    self.postNotification = properties[@"postNotification"];
    self.selectionAllowance =
        abs(properties[@"selectionAllowance"]
                ? [properties[@"selectionAllowance"] intValue]
                : 0);

    NSString *appList = [properties[@"appList"] lowercaseString];

    if ([appList isEqualToString:@"allapps"]) {
        self.fullAppList = [KBAppList.allApps copy];
    } else if ([appList isEqualToString:@"userapps"]) {
        self.fullAppList = [KBAppList.userApps copy];
    } else if ([appList isEqualToString:@"systemapps"]) {
        self.fullAppList = [KBAppList.systemApps copy];
    } else if ([appList isEqualToString:@"audioapps"]) {
        self.fullAppList = [KBAppList.audioApps copy];
    }

    if (self.selectionAllowance == 0 ||
        self.selectionAllowance > self.fullAppList.count) {
        self.selectionAllowance = self.fullAppList.count;
    }

    if (!([self.preferencesSuiteName length] == 0 ||
          [self.preferencesKey length] == 0)) {
        NSUserDefaults *preferences = [[NSUserDefaults alloc]
            initWithSuiteName:self.preferencesSuiteName];
        self.selectedApps =
            [[preferences objectForKey:self.preferencesKey] mutableCopy];
    } else {
        [self errorAlert];
    }

    if (!self.selectedApps && [[properties[@"default"] lowercaseString]
                                  isEqualToString:@"selected"]) {

        NSArray *tempArray = [self.fullAppList
            subarrayWithRange:NSMakeRange(0, self.selectionAllowance)];
        self.selectedApps = [tempArray mutableCopy];

        [self savePreferences];
    } else if (!self.selectedApps) {
        self.selectedApps = [NSMutableArray new];
    }
    NSMutableArray *sortingArray = [NSMutableArray new];
    for (id object in self.selectedApps) {
        if ([object isKindOfClass:[NSDictionary class]] &&
            [(NSDictionary *)object objectForKey:@"bundleID"] &&
            [(NSDictionary *)object objectForKey:@"name"]) {
            [sortingArray addObject:object];
        }
    }
    self.selectedApps = [sortingArray mutableCopy];

    self.unselectedApps = [self.fullAppList mutableCopy];
    [self.unselectedApps removeObjectsInArray:self.selectedApps];

    self.resultsTableController.searchResult =
        [NSMutableArray arrayWithCapacity:[self.fullAppList count]];

    ////Navigation Bar
    self.quickEdit = NO;

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                             target:self
                             action:@selector(toggleSearch)];

    UIBarButtonItem *quickEditButton =
        [[UIBarButtonItem alloc] initWithTitle:@"QuickEdit"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(toggleQuickEdit:)];

    self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:quickEditButton, searchButton, nil];
}

////NavButton Methods

- (void)toggleSearch {
    if (self.searchController.active) {
        self.searchController.active = NO;
    } else {
        self.searchController.active = YES;
    }
}

- (void)toggleQuickEdit:(UIBarButtonItem *)barButton {
    if (self.quickEdit) {
        /// Add app to new location
        [self.selectedApps addObjectsFromArray:unselectedToMove];
        [self.unselectedApps addObjectsFromArray:selectedToMove];
        /// remove from old location
        [self.selectedApps removeObjectsInArray:selectedToMove];
        [self.unselectedApps removeObjectsInArray:unselectedToMove];

        [self savePreferences];
        // Reset array
        unselectedToMove = nil;
        selectedToMove = nil;
        self.longPress.enabled = YES;
        barButton.title = @"QuickEdit";
        self.quickEdit = NO;

        self.collectionView.allowsSelection = NO;
        self.collectionView.allowsMultipleSelection = NO;
    } else {
        self.longPress.enabled = NO;
        barButton.title = @"Done";
        self.quickEdit = YES;
        self.collectionView.allowsSelection = YES;
        self.collectionView.allowsMultipleSelection = YES;
    }
    [self.collectionView
        reloadSections:[NSIndexSet
                           indexSetWithIndexesInRange:
                               NSMakeRange(
                                   0, self.collectionView.numberOfSections)]];
}

////UICollectionView Delegates

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    ALHeaderView *headerView =
        [collectionView dequeueReusableSupplementaryViewOfKind:
                            UICollectionElementKindSectionHeader
                                           withReuseIdentifier:@"header"
                                                  forIndexPath:indexPath];
    headerView.backgroundColor = UIColor.whiteColor;

    if (indexPath.section == 0) {
        if (self.selectedApps.count == self.selectionAllowance) {
            headerView.label.text = @"Selected - Full";
        } else if (self.selectedApps.count > self.selectionAllowance) {
            headerView.label.text = @"Selected- Too Many";
        } else {
            headerView.label.text = @"Selected";
        }
    } else {
        headerView.label.text = @"Unselected";
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                             layout:(UICollectionViewFlowLayout *)
                                        collectionViewLayout
    referenceSizeForHeaderInSection:(NSInteger)section {

    return collectionViewLayout.headerReferenceSize;
}

- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {

    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {

    if (section == 0) {
        count = self.selectedApps.count;
    } else {
        count = self.unselectedApps.count;
    }

    if (!count) {
        count = 1;
    }

    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ALAppCell *cell;
    int numberOfItem =
        [collectionView numberOfItemsInSection:indexPath.section];
    NSMutableArray *dataSourceArray;

    if (numberOfItem == 1) {
        cell =
            [collectionView dequeueReusableCellWithReuseIdentifier:@"HOLDERCELL"
                                                      forIndexPath:indexPath];
    } else if (indexPath.row == numberOfItem - 1) {
        cell =
            [collectionView dequeueReusableCellWithReuseIdentifier:@"BOTTOMCELL"
                                                      forIndexPath:indexPath];
    } else if (indexPath.row == 0) {
        cell =
            [collectionView dequeueReusableCellWithReuseIdentifier:@"TOPCELL"
                                                      forIndexPath:indexPath];
    } else {
        cell =
            [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL"
                                                      forIndexPath:indexPath];
    }

    if (cell.selected) {
        cell.contentView.backgroundColor = highlightColor;
    } else {
        cell.contentView.backgroundColor = UIColor.whiteColor;
    }
    cell.iconImageView.image = nil;

    if (self.quickEdit) {
        cell.accessoryImageView.hidden = YES;
    } else {
        cell.accessoryImageView.hidden = NO;
    }

    if (indexPath.section == 0) {
        dataSourceArray = self.selectedApps;
    } else {
        dataSourceArray = self.unselectedApps;
    }

    if (dataSourceArray.count) {

        cell.label.text = [[dataSourceArray objectAtIndex:indexPath.row]
            objectForKey:@"name"];
        cell.iconImageView.image = [UIImage
            _applicationIconImageForBundleIdentifier:
                [[dataSourceArray objectAtIndex:indexPath.row]
                    objectForKey:@"bundleID"]
                                              format:1
                                               scale:UIScreen.mainScreen.scale];

    } else {
        cell.label.text = nil;
        cell.accessoryImageView.hidden = YES;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewFlowLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionViewLayout.itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:
                            (UICollectionViewFlowLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gr {

    switch (gr.state) {
    case UIGestureRecognizerStateBegan: {
        NSIndexPath *selectedIndexPath = [self.collectionView
            indexPathForItemAtPoint:[gr locationInView:self.collectionView]];
        if (selectedIndexPath == nil)
            break;
        [self.collectionView
            beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
        movingCell = (ALAppCell *)[self.collectionView
            cellForItemAtIndexPath:selectedIndexPath];

        movingCell.layer.zPosition = 15;
        break;
    }
    case UIGestureRecognizerStateChanged: {

        [self.collectionView
            updateInteractiveMovementTargetPosition:
                CGPointMake(gr.view.center.x, [gr locationInView:gr.view].y)];

        break;
    }
    case UIGestureRecognizerStateEnded: {

        [self.collectionView endInteractiveMovement];
        movingCell.layer.zPosition = 0;
        [self savePreferences];
        break;
    }
    default: {
        [self.collectionView cancelInteractiveMovement];
        movingCell.layer.zPosition = 0;
        break;
    }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView
    shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 &&
        (unselectedToMove.count + 1 + self.selectedApps.count -
             selectedToMove.count >
         self.selectionAllowance)) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView
    shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 &&
        ((unselectedToMove.count - selectedToMove.count) +
             self.selectedApps.count >=
         self.selectionAllowance)) {

        return NO;
    } else {
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ALAppCell *cell =
        (ALAppCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = highlightColor;

    if (indexPath.section == 0) {
        if (!selectedToMove) {
            selectedToMove = [NSMutableArray new];
        } /// check array exists
        [selectedToMove
            addObject:[self.selectedApps objectAtIndex:indexPath.row]];
    } else {
        if (!unselectedToMove) {
            unselectedToMove = [NSMutableArray new];
        } /// check array exists
        [unselectedToMove
            addObject:[self.unselectedApps objectAtIndex:indexPath.row]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
    didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    ALAppCell *cell =
        (ALAppCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColor.whiteColor;

    if (indexPath.section == 0) {
        [selectedToMove
            removeObject:[self.selectedApps objectAtIndex:indexPath.row]];
    } else {
        [unselectedToMove
            removeObject:[self.unselectedApps objectAtIndex:indexPath.row]];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView
    canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && !self.selectedApps.count) ||
        (indexPath.section == 1 && !self.unselectedApps.count) ||
        (indexPath.section == 1 &&
         (unselectedToMove.count + 1 + self.selectedApps.count >
          self.selectionAllowance))) {
        return NO;
    } else {
        return YES;
    }
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView
    targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath
                          toProposedIndexPath:(NSIndexPath *)proposedIndexPath {

    if ((proposedIndexPath.section == 0 &&
         proposedIndexPath.row >= self.selectedApps.count &&
         !self.selectedApps.count) ||
        (proposedIndexPath.section == 1 &&
         proposedIndexPath.row >= self.unselectedApps.count &&
         !self.unselectedApps.count)) {
        return [NSIndexPath indexPathForRow:0
                                  inSection:proposedIndexPath.section];
    } else {
        return proposedIndexPath;
    }
}

- (void)collectionView:(UICollectionView *)collectionView
    moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
            toIndexPath:(NSIndexPath *)destinationIndexPath {

    NSMutableArray *tempCopyArray;

    /// Removing from source array
    if (sourceIndexPath.section == 0) {

        tempCopyArray = [NSMutableArray arrayWithArray:self.selectedApps];
        [self.selectedApps
            removeObject:[tempCopyArray objectAtIndex:sourceIndexPath.row]];

    } else {

        tempCopyArray = [NSMutableArray arrayWithArray:self.unselectedApps];
        [self.unselectedApps
            removeObject:[tempCopyArray objectAtIndex:sourceIndexPath.row]];
    }

    /// Adding to destination array
    if (destinationIndexPath.section == 0) {
        if (!self.selectedApps) {
            self.selectedApps = [[NSMutableArray alloc] init];
        } /// check array exist
        [self.selectedApps
            insertObject:[tempCopyArray objectAtIndex:sourceIndexPath.row]
                 atIndex:destinationIndexPath.row];
    } else {
        if (!self.unselectedApps) {
            self.unselectedApps = [[NSMutableArray alloc] init];
        } /// check array exists
        [self.unselectedApps
            insertObject:[tempCopyArray objectAtIndex:sourceIndexPath.row]
                 atIndex:destinationIndexPath.row];
    }

    [[self.collectionView collectionViewLayout] invalidateLayout];
    [self.collectionView setNeedsLayout];

    [self.collectionView
        reloadSections:[NSIndexSet
                           indexSetWithIndexesInRange:
                               NSMakeRange(
                                   0, self.collectionView.numberOfSections)]];

    [self.collectionView layoutIfNeeded];

    // add your data source manipulation logic here
    // specifically, change the order of entries in the data source to match the
    // new visual order of the cells. even without anything inside this
    // function, the cells will move visually if you build and run
}

////UISearchBar Delegates

- (void)presentSearchController:(UISearchController *)searchController {
    [self presentViewController:self.searchController
                       animated:YES
                     completion:nil];
    self.resultsTableController.searchTable.delegate = self;
    self.resultsTableController.searchTable.dataSource = self;
    self.resultsTableController.searchTable.tableFooterView = [UIView new];
    self.resultsTableController.searchTable.separatorInset =
        UIEdgeInsetsMake(0, 10, 0, 10);
    self.resultsTableController.searchTable.separatorColor = UIColor.whiteColor;
}

- (void)updateSearchResultsForSearchController:
    (UISearchController *)searchController {
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        self.resultsTableController.searchEnabled = NO;
    } else {
        self.resultsTableController.searchEnabled = YES;
        [self filterContentForSearchText:searchBar.text];
    }
    [self.resultsTableController.searchTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.resultsTableController.searchEnabled = YES;
    [self filterContentForSearchText:searchBar.text];

    if (self.resultsTableController.searchResult.count) {

        id object = [self.resultsTableController.searchResult firstObject];
        int usedArraySection =
            self.selectedApps.count && [self.selectedApps containsObject:object]
                ? 0
                : self.unselectedApps.count &&
                          [self.unselectedApps containsObject:object]
                      ? 1
                      : 2;

        NSMutableArray *usedArray =
            usedArraySection == 0
                ? self.selectedApps
                : usedArraySection == 1 ? self.unselectedApps : nil;
        self.searchController.active = NO;

        NSIndexPath *indexPath =
            [NSIndexPath indexPathForRow:[usedArray indexOfObject:object]
                               inSection:usedArraySection];

        [self.collectionView
            scrollToItemAtIndexPath:
                [NSIndexPath indexPathForRow:[usedArray indexOfObject:object]
                                   inSection:usedArraySection]
                   atScrollPosition:UICollectionViewScrollPositionBottom
                           animated:NO];

        if (indexPath.row != 0 && indexPath.section != 0) {
            [self.collectionView
                setContentOffset:CGPointMake(
                                     0,
                                     self.collectionView.contentOffset.y + 60)];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    self.resultsTableController.searchEnabled = NO;
    [self.resultsTableController.searchTable reloadData];
}

- (void)filterContentForSearchText:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate
        predicateWithFormat:@"%K CONTAINS[cd] %@", @"name", searchText];

    self.resultsTableController.searchResult =
        [self.fullAppList filteredArrayUsingPredicate:predicate];

    [self.resultsTableController.searchTable reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    if (self.resultsTableController.searchEnabled) {
        return [self.resultsTableController.searchResult count];
    } else {
        return [self.fullAppList count];
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";

    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell =
            [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier];
    }
    if (self.resultsTableController.searchEnabled) {
        cell.textLabel.text = [[self.resultsTableController.searchResult
            objectAtIndex:indexPath.row] objectForKey:@"name"];

    } else {
        cell.textLabel.text = [[self.fullAppList objectAtIndex:indexPath.row]
            objectForKey:@"name"];
    }
    cell.backgroundColor = UIColor.clearColor;
    cell.textLabel.textColor = UIColor.whiteColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.searchController.searchBar.text = cell.textLabel.text;
    [self searchBarSearchButtonClicked:self.searchController.searchBar];
}

/// Save appList

- (void)savePreferences {
    NSUserDefaults *preferences =
        [[NSUserDefaults alloc] initWithSuiteName:self.preferencesSuiteName];
    [preferences setObject:self.selectedApps forKey:self.preferencesKey];
    ///[preferences synchronize];

    if (self.postNotification) {
        CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
        CFNotificationCenterPostNotification(
            r, (CFStringRef)self.postNotification, NULL, NULL, true);
    }
}

- (void)errorAlert {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Error loading prefs"
                         message:@"Oh no! Something went wrong!"
                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action){
                                   // Ok action example
                               }];

    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end