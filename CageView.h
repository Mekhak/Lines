//
//  CageView.h
//  Lines
//
//  Created by Mekhak on 8/18/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BallView.h"

@class CageView;

@protocol CageViewDelegate <NSObject>

- (void)cageViewTapped: (CageView*)view;

@end



@interface CageView : UIView

@property BallView* ball;

@property id<CageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
