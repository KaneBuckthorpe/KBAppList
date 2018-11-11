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
@property (nonatomic,assign) NSString* postNotificationID; 
@property (nonatomic,assign) NSString* preferencesID; 
@property (nonatomic,assign) int selectionAllowance; 
@end

