
@interface KBAppItem:NSObject
@property (nonatomic, strong) NSString*appName;
@property (nonatomic, strong) NSString*appBundleID;
@end

@interface KBAppList :NSObject
@property (nonatomic, strong) NSArray <KBAppItem*> * appsList;
@property (nonatomic, strong) NSArray <KBAppItem*> * systemAppsList;
@property (nonatomic, strong) NSArray <KBAppItem*> * filteredAppsList;
@property (nonatomic, strong) NSArray <KBAppItem*> * mediaAppsList;
+ (id)sharedInstance;
-(void)refreshAppLists;
@end