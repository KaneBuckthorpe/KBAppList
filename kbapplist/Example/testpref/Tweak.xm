#import <UIKit/UIKit.h>
#import <KBAppList/KBAppList.h>

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
  %orig;
NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.kbapplist"];
NSArray*musicApps = [preferences objectForKey:@"KBMusicAppList"];
NSArray *musicAppsName = [musicApps valueForKey:@"name"];
NSArray *musicAppsID = [musicApps valueForKey:@"bundleID"];

NSLog(@"musicDict:%@", musicApps);

NSLog(@"selected music apps name:%@   bundleID:%@",musicAppsName, musicAppsID);

  ///Logging a list of installed apps on SpringBoards launch.
            }
            %end
            