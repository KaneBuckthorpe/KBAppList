#import "libKBAppList.h"

@implementation KBAppList
+ (id)sharedInstance{
    static KBAppList *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBAppList alloc] init];

    });
    return sharedInstance;
}
- (id)init {
  if (self = [super init]) {
     ///setup array

[self setupLists];
  }
  return self;
}

-(void)setupLists{
[self setupAllAppsList];
[self setupSystemAppsList];
[self setupFilteredAppList];
[self setupMediaAppsList];
}

-(void)setupAllAppsList{
    NSMutableArray* sortingAppList= [ NSMutableArray new];
    NSMutableArray* sortingAppBundleID= [ NSMutableArray new];
    
    for (LSApplicationProxy *app in [[%c(LSApplicationWorkspace) defaultWorkspace] allInstalledApplications]) {
  
            [sortingAppList addObject:app.localizedName];
            [sortingAppBundleID addObject:app.bundleIdentifier];
        
    }
    
}

-(void)setupSystemAppsList{

NSArray *systemApps = @[@"com.apple.fieldtest",@"com.apple.gamecenter.GameCenterUIService",@"com.apple.HealthPrivacyService",@"com.apple.InCallService",@"com.apple.MailCompositionService",@"com.apple.mobilesms.compose",@"com.apple.MusicUIService",@"com.apple.PassbookUIService",@"com.apple.PhotosViewService",@"com.apple.PreBoard",@"com.apple.social.SLGoogleAuth",@"com.apple.social.SLYahooAuth",@"com.apple.SafariViewService",@"com.apple.mobilecal",@"org.coolstar.SafeMode",@"com.apple.ScreenSharingviewService",@"com.apple.ScreenshotServicesService",@"com.apple.purplebuddy",@"com.apple.SharedWebCredentialViewService",@"com.apple.SharingViewService",@"com.apple.susuiservice",@"com.apple.StoreDemoViewService",@"com.apple.ios.StoreKitUIService",@"com.apple.TrustMe",@"com.apple.VSViewService",@"com.apple.WLAccessService",@"com.apple.webapp1",@"com.apple.webapp",@"com.apple.reminders",@"com.apple.WebSheet",@"com.apple.iad.iAdOptOut",@"com.apple.CloudKit.ShareBear",@"com.apple.AXUIViewService",@"com.apple.AccountAuthenticationDialog",@"com.apple.AskPermissionUI",@"com.apple.CTCarrierSpaceAuth",@"com.apple.CheckerBoard",@"com.apple.CompassCalibrationViewService",@"com.apple.CoreAuthUI",@"com.apple.datadetectors.DDActionsService",@"com.apple.carkit.DNDBuddy",@"com.apple.DataActivation",@"com.apple.DemoApp",@"com.apple.DiagnosticsService",@"com.apple.Diagnostics",@"com.apple.FTMInternal",@"com.apple.PrintKit.Print-Center",@"com.apple.ScreenSharingViewService",@"com.apple.ServerDocuments",@"com.apple.WebContentFilter.remoteUI.WebContentAnalysisUI",@"com.apple.AdPlatformsDiagnostics",@"com.apple.AdSheetPhone"];

self.systemAppsList=systemApps;
}
@end
