#import <UIKit/UIKit.h>
#import <KBAppList/KBAppList.h>

static void loadPrefs() {
NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.example.tweak"];
NSArray *apps = [preferences objectForKey:@"UNIQUEID"];
NSArray *appsName = [apps valueForKey:@"name"];
NSArray *appsID = [apps valueForKey:@"bundleID"];
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
  NSLog(@"musicDict:%@", musicApps);

  NSLog(@"selected music apps name:%@   bundleID:%@",musicAppsName, musicAppsID);

  //Logging a list of installed apps on SpringBoards launch.
}
%end
