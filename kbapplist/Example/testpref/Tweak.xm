#import <UIKit/UIKit.h>
#import <KBAppList/KBAppList.h>

static void
loadPrefs() {
NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.example.tweak"];
NSArray *apps = [preferences objectForKey:@"UNIQUEID"];
NSArray *appsName = [apps valueForKey:@"name"];
NSArray *appsID = [apps valueForKey:@"bundleID"];
}

//Optional for real time pref change
%ctor {
    CFNotificationCenterAddObserver(
    CFNotificationCenterGetDarwinNotifyCenter(), NULL,
    (CFNotificationCallback)loadPrefs,
    CFSTR("com.example.tweak-prefsreload"), NULL,
    CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();
}

%hook SpringBoard
loadPrefs(); //Only put this here if you didnt use the code above
- (void)applicationDidFinishLaunching:(id)application {
  %orig;
  NSLog(@"musicDict:%@", musicApps);

  NSLog(@"selected music apps name:%@   bundleID:%@",musicAppsName, musicAppsID);

  //Logging a list of installed apps on SpringBoards launch.
}
%end
