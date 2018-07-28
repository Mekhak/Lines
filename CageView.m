//
//  CageView.m
//  Lines
//
//  Created by Mekhak on 8/18/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "CageView.h"

@implementation CageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.backgroundColor = [UIColor grayColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2;
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGFloat ballRectSize = (width < height) ? width : height;
        CGRect ballRect = CGRectMake(0, 0, ballRectSize - 8, ballRectSize - 8);
        
        self.ball = [[BallView alloc]initWithFrame:ballRect];
        
        self.ball.center = CGPointMake(width / 2, height / 2);
        
        [self addSubview:self.ball];
        
        self.ball.hidden = YES;
    }
    
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([self.delegate respondsToSelector:@selector(cageViewTapped:)])
    {
        [self.delegate cageViewTapped:self];
    }
}

@end
