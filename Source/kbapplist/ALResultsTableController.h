
@interface ALResultsTableController : UIViewController
@property(nonatomic, retain) UITableView *searchTable;
@property(nonatomic, strong) NSArray *searchResult;
@property(nonatomic, assign) BOOL searchEnabled;
@end