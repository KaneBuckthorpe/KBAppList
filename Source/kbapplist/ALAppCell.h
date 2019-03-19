//
//  ALAppCell.h
//  ReordableUICollectionView
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//
#import "KBAppList.h"
#import <UIKit/UIKit.h>

@interface ALAppCell : UICollectionViewCell
@property(nonatomic, retain) UIImageView *iconImageView;
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIImageView *accessoryImageView;
@property(nonatomic, retain) UIView *shadowView;
@property(nonatomic, assign) CGFloat shadowRadius;
@end

@interface ALTopCell : ALAppCell
@end

@interface ALBottomCell : ALAppCell
@end

@interface ALHolderCell : ALAppCell
@end

@interface UIView (custom)
- (UIView *)setShadowCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;
- (UIView *)setRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;
@end