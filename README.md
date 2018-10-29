# KBAppList
Framework for access to lists of installed apps and a cool app selection preference panes!

This framework provides four different lists of apps for use in tweaks:
-All Apps
-User Installed Apps
-System Apps
-Audio Apps


The preferences, unlike all other iOS preference panes makes use of a UICollectionView with a fresh but iOS like look rather then the standard UITableView.
It comes with drag and drop, quick edit, and search capabillities to improve user use within you tweaks.

Requires a unique ID key for saving the list in preferences, which can be retrieved in a number of ways. The recommended method is NSUserDefaults.
Can also take a Post Notification Key, to allow you to instantly retrieve the new listed of selected apps whenever a change to the selected apps is made.

Example use has been provided. 

![KBAppList](repo_assets/KBAppList.png)
![KBAppList](repo_assets/search.png)


## Information
| #### Available Lists | All Apps | User Apps | System Apps | Audio Apps |
|-----------------|----------|-----------|-------------|------------|


