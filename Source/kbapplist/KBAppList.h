
@interface KBAppList : NSObject
+ (NSMutableArray *)allApps;
+ (NSMutableArray *)userApps;
+ (NSMutableArray *)systemApps;
+ (NSMutableArray *)audioApps;
@end