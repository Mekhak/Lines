//
//  BallView.m
//  Lines
//
//  Created by Mekhak on 8/18/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "BallView.h"

@implementation BallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}


@end
