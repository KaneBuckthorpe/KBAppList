//
//  ALAppCell.m
//  ReordableUICollectionView
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//

#import "ALAppCell.h"
#import <Foundation/Foundation.h>

@implementation ALAppCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.shadowView = [[UIView alloc] initWithFrame:self.bounds];
        self.shadowView.backgroundColor = UIColor.clearColor;
        [self setShadowForView:self.shadowView];
        [self.shadowView
            setShadowCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                  withRadius:0];
        [self.contentView
            setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                   withRadius:0];
        [self addSubview:self.shadowView];
        [self bringSubviewToFront:self.contentView];

        CGFloat insetLX = 20;
        CGFloat insetRX = 50;
        CGFloat insetY = 5;
        CGFloat contentHeight = frame.size.height - (2 * insetY);
        self.iconImageView = [[UIImageView alloc]
            initWithFrame:CGRectMake(insetLX, insetY, contentHeight,
                                     contentHeight)];
        [self.contentView addSubview:self.iconImageView];

        insetLX = self.iconImageView.frame.origin.x + contentHeight + 20;
        self.label = [[UILabel alloc]
            initWithFrame:CGRectMake(insetLX, insetY,
                                     frame.size.width - insetLX - insetRX - 20,
                                     contentHeight)];
        [self.contentView addSubview:self.label];

        self.accessoryImageView = [[UIImageView alloc]
            initWithFrame:CGRectMake(frame.size.width - insetRX + 5, insetY + 5,
                                     contentHeight - 10, contentHeight - 10)];
        [self.contentView addSubview:self.accessoryImageView];

        self.iconImageView.backgroundColor = UIColor.clearColor;
        self.iconImageView.layer.cornerRadius = contentHeight / 2;

        [self.label setFont:[UIFont fontWithName:@".SFUIDisplay" size:20]];
        self.label.text = @"App Name";
        self.accessoryImageView.backgroundColor = UIColor.clearColor;
        self.accessoryImageView.layer.cornerRadius =
            (self.accessoryImageView.bounds.size.height / 2);

        self.accessoryImageView.image = [UIImage
                               imageNamed:@"listView"
                                 inBundle:[NSBundle
                                              bundleForClass:KBAppList.class]
            compatibleWithTraitCollection:nil];

        self.contentView.backgroundColor = UIColor.whiteColor;

        self.layer.zPosition = 0;
    }
    return self;
}
- (void)setShadowForView:(UIView *)view {

    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowRadius = 1.0f;
    view.layer.shadowOpacity = 1.0f;
    view.layer.masksToBounds = NO;

    self.shadowRadius = self.frame.size.width / 2;
}

@end

@implementation UIView (custom)

- (UIView *)setShadowCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {

    UIBezierPath *maskPath =
        [UIBezierPath bezierPathWithRoundedRect:self.bounds
                              byRoundingCorners:corners
                                    cornerRadii:CGSizeMake(radius, radius)];

    self.layer.frame = self.bounds;

    self.layer.shadowPath = maskPath.CGPath;

    return self;
}
- (UIView *)setRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {
    UIBezierPath *maskPath =
        [UIBezierPath bezierPathWithRoundedRect:self.bounds
                              byRoundingCorners:corners
                                    cornerRadii:CGSizeMake(radius, radius)];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];

    maskLayer.frame = self.bounds;

    maskLayer.path = maskPath.CGPath;

    self.layer.mask = maskLayer;

    return self;
}
@end

@implementation ALTopCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.shadowView
            setShadowCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                  withRadius:self.shadowRadius];
        [self.contentView
            setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                   withRadius:self.shadowRadius];
    }
    return self;
}
@end

@implementation ALBottomCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.shadowView
            setShadowCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                  withRadius:self.shadowRadius];
        [self.contentView
            setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                   withRadius:self.shadowRadius];
    }
    return self;
}
@end

@implementation ALHolderCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.shadowView
            setShadowCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight |
                             UIRectCornerTopLeft | UIRectCornerTopRight
                  withRadius:self.shadowRadius];
        [self.contentView
            setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight |
                              UIRectCornerTopLeft | UIRectCornerTopRight
                   withRadius:self.shadowRadius];
    }
    return self;
}
@end