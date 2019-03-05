# KBAppList

Framework for access to lists of installed apps and cool app selection preference panes!

The preferences, unlike all other iOS preference panes makes use of a UICollectionView with a fresh but iOS like look rather then the standard UITableView.
It comes with drag and drop, quick edit, and search capabillities to improve user experience within your tweaks.

Requires a unique ID for saving the list in preferences, which can be retrieved in a number of ways. The recommended method is NSUserDefaults.
Can also use Post Notification, to allow you to instantly retrieve the new listed of selected apps whenever a change to the selected apps is made.

| Downloads: | [Latest Release](https://github.com/kanesbetas/KBAppList/releases/latest) | [Headers](https://github.com/kanesbetas/KBAppList/tree/master/kbapplist/headers) | [Example Use](https://github.com/kanesbetas/KBAppList-Example) | [Package](https://github.com/kanesbetas/KBAppList/tree/master/kbapplist/packages) | [Framework](https://github.com/kanesbetas/KBAppList/tree/master/kbapplist/Framework)   |
## How To Use?

First, You have to install the latest [deb](https://github.com/kanesbetas/KBAppList/tree/master/kbapplist/packages).
when the installation process is complete, you have to add the latest KBAppList [framework](https://github.com/kanesbetas/KBAppList/tree/master/kbapplist/Framework) to /theos/lib/. <br/><br/> Now we can move onto the tweak's folder. First you would need to add
 KBAppList as a dependancy, this can be done by add it to the control file like `Depends: mobilesubstrate, com.kaneb.kbapplist`. Next You would need to add `TWEAKSNAME_EXTRA_FRAMEWORKS += KBAppList` in the makefile in the Preferences folder. <br/><br/>
 It is really easy to add a tab to view the applist inside your preferences, all you need to do is add this inside your <b>root.plist</b>

        <dict>
           <key>key</key>
           <string>UNIQUEID</string> <!-- your unique prefs key, for retrieving selected apps in your tweak -->
           <key>defaults</key>
           <string>com.example.tweak</string> <!-- The pref's bundleID -->
           <key>default</key>
           <string></string> <!-- This will default to all apps being unselected -->
           <key>appList</key>
           <string>allApps</string> <!-- Choose which apps should be displayed for selection -->
           <key>label</key>
           <string>DISPLAYNAME</string> <!-- What the tab will be called in the settings app -->
           <key>postNotification</key> <!-- This is if you want to use system notifications for real time preference changes -->
           <string>com.example.tweak-prefsreload</string>
           <key>cell</key>
           <string>PSLinkCell</string>
           <key>detail</key>
           <string>ALViewController</string>
           <key>icon</key>
           <string>iconpath.png</string>
           <key>isController</key>
           <true/>
         </dict>

Finally retrieving the values from the Tweak.xm file can be easily done like such.

  ```
    NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.example.tweak"];
    NSArray *apps = [preferences objectForKey:@"UNIQUEID"];
    NSArray *appsName = [apps valueForKey:@"name"];
    NSArray *appsID = [apps valueForKey:@"bundleID"];
  ```
If you are going to use postNotifcation you can use this outside the %hook.
```
static void loadPrefs() {
NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.example.tweak"];
NSArray *apps = [preferences objectForKey:@"UNIQUEID"];
NSArray *appsName = [apps valueForKey:@"name"];
NSArray *appsID = [apps valueForKey:@"bundleID"];
}

%ctor {
    CFNotificationCenterAddObserver(
    CFNotificationCenterGetDarwinNotifyCenter(), NULL,
    (CFNotificationCallback)loadPrefs,
    CFSTR("com.example.tweak-prefsreload"), NULL,
    CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();
}
```

## Information

#### Preferences

|        Keys        |    Option 1   |       Option 2      |  Option 3 |   Option 4  |
| :----------------: | :-----------: | :-----------------: | :-------: | :---------: |
|         key        | UNIQUE STRING |                     |           |             |
|      defaults      | UNIQUE bundleID |                     |           |             |
|       default      |   "selected"  | "unselected" or nil |           |             |
|  postNotification  | UNIQUE BUNDLEID |         nil         |           |             |
|       appList      |   "userApps"  |     "systemApps"    | "allApps" | "audioApps" |
|        label       |     STRING    |         nil         |           |             |
| selectionAllowance |    INTEGER    |         nil         |           |             |

* * *

![KBAppList](repo_assets/KBAppList.png)
![KBAppList](repo_assets/search.png)

* * *

## License

Please dont steel code!

This software is licensed under the BSD 4 License, detailed in the file [LICENSE.md](https://github.com/kanesbetas/KBAppList/blob/master/LICENSE.md)
If you do wish to use this code in your project then in addition to the License agreement you must also provide a link to my twitter [@IndieDevKB](https://twitter.com/indiedevkb). If for any reason you do not wish to include my website in your project, then please contact me so we can discuss another agreement.
