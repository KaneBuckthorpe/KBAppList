//
//  ALViewController.h
//  ReordableUICollectionView
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//
#import <Preferences/PSViewController.h>

@interface ALViewController : PSViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *fullAppList;
@property (nonatomic, strong) NSMutableArray *selectedApps;
@property (nonatomic, strong) NSMutableArray *unselectedApps;
@property (nonatomic,assign) NSString* postNotification; 
@property (nonatomic,assign) NSString* preferencesSuiteName; 
@property (nonatomic,assign) NSString* preferencesKey; 
@property (nonatomic,assign) int selectionAllowance; 
@end

