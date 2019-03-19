//
//  HeaderView.m
//  ReordableUICollectionView
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//

#import "ALHeaderView.h"
#import <Foundation/Foundation.h>

@implementation ALHeaderView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label =
            [[UILabel alloc] initWithFrame:CGRectMake(20, 0, frame.size.width,
                                                      frame.size.height)];
        [self addSubview:self.label];
        [self.label setFont:[UIFont fontWithName:@".SFUIDisplay-Bold" size:33]];
        self.label.textColor = UIColor.blackColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 1.5f);
        self.layer.shadowRadius = 0.75f;
        self.layer.shadowOpacity = 1.0f;
        self.layer.masksToBounds = NO;
        self.layer.zPosition = 1;
    }
    return self;
}
@end