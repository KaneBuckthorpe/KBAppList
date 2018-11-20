#import <UIKit/UIKit.h>
#import <KBAppList/KBAppList.h>

NSArray *appsName;
NSArray *appsID;

static void loadPrefs() {
NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.example.tweak"];
NSArray *apps = [preferences objectForKey:@"UNIQUEID"];
appsName = [apps valueForKey:@"name"];
appsID = [apps valueForKey:@"bundleID"];
}

//Optional if using postNotifcation, if not just ignore this
%ctor {
    CFNotificationCenterAddObserver(
    CFNotificationCenterGetDarwinNotifyCenter(), NULL,
    (CFNotificationCallback)loadPrefs,
    CFSTR("com.example.tweak-prefsreload"), NULL,
    CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();
}

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
  %orig;

  NSLog(@"selected music apps name:%@ and bundleID:%@",musicAppsName, musicAppsID);

  //Logging a list of selected apps on SpringBoards launch.
}
%end
