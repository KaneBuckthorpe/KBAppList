#import "KBAppList.h"
#import <UIKit/UIKit.h>

@interface _LSLazyPropertyList : NSObject
@property(readonly) NSDictionary *propertyList;
@end

@interface LSApplicationProxy : NSObject
@property(setter=_setLocalizedName:, nonatomic, copy) NSString *localizedName;
@property(nonatomic, readonly) NSString *bundleIdentifier;
@property(nonatomic, readonly) NSString *primaryIconName;
@property(nonatomic, readonly) NSDictionary *iconsDictionary;
@property(nonatomic, readonly) NSArray *appTags;
@property(setter=_setInfoDictionary:, nonatomic, copy)
    _LSLazyPropertyList *_infoDictionary;
- (NSArray *)_boundIconFileNames; // iOS 11 and up
- (NSArray *)boundIconFileNames;  // iOS 10 and below
@end

@interface LSApplicationWorkspace
+ (id)defaultWorkspace;
- (id)allInstalledApplications;
- (id)allApplications;
- (id)applicationsOfType:(unsigned long long)arg1;
- (id)applicationsWithUIBackgroundModes;
@end

@interface KBAppList ()
+ (NSString *)nameForApp:(LSApplicationProxy *)app;
@end

@implementation KBAppList
BOOL iOS11AndPlus = kCFCoreFoundationVersionNumber > 1400;
int iOSVersion;
+ (NSMutableArray *)userApps {

    NSMutableArray *userApps = [NSMutableArray new];
    NSMutableArray *defaultWorkspaceApps =
        [[NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace]
            applicationsOfType:0];

    for (LSApplicationProxy *app in defaultWorkspaceApps) {
        [userApps addObject:@{
            @"bundleID" : app.bundleIdentifier,
            @"name" : [self nameForApp:app]
        }];
    }
    return userApps;
}

+ (NSMutableArray *)audioApps {

    NSMutableArray *audioApps = [NSMutableArray new];
    NSMutableArray *defaultWorkspaceApps =
        [[NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace]
            applicationsWithUIBackgroundModes];

    for (LSApplicationProxy *app in defaultWorkspaceApps) {
        NSDictionary *info = app._infoDictionary.propertyList;
        NSArray *background = info[@"UIBackgroundModes"];
        if (background && [background containsObject:@"audio"]) {
            if ([self hasIconAndVisible:app]) {
                [audioApps addObject:@{
                    @"bundleID" : app.bundleIdentifier,
                    @"name" : [self nameForApp:app]
                }];
            }
        }
    }
    return audioApps;
}

+ (NSMutableArray *)systemApps {

    NSMutableArray *systemApps = [NSMutableArray new];
    NSMutableArray *defaultWorkspaceApps =
        [[NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace]
            applicationsOfType:1];

    for (LSApplicationProxy *app in defaultWorkspaceApps) {
        if ([self hasIconAndVisible:app]) {
            [systemApps addObject:@{
                @"bundleID" : app.bundleIdentifier,
                @"name" : [self nameForApp:app]
            }];
        }
    }

    return systemApps;
}

+ (NSMutableArray *)allApps {

    NSMutableArray *allApps = [NSMutableArray new];
    NSMutableArray *defaultWorkspaceApps =
        [[NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace]
            allApplications];
    for (LSApplicationProxy *app in defaultWorkspaceApps) {
        if ([self hasIconAndVisible:app]) {
            [allApps addObject:@{
                @"bundleID" : app.bundleIdentifier,
                @"name" : [self nameForApp:app]
            }];
        }
    }
    return allApps;
}

+ (BOOL)hasIconAndVisible:(LSApplicationProxy *)app {

    NSArray *iconNames =
        (iOS11AndPlus) ? app._boundIconFileNames : app.boundIconFileNames;
    if ((app.iconsDictionary || iconNames) &&
        ![app.appTags containsObject:@"hidden"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)nameForApp:(LSApplicationProxy *)app {
    return (app.localizedName ? app.localizedName : app.bundleIdentifier);
}
@end