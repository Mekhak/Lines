//
//  HighScoreViewController.m
//  Lines
//
//  Created by Mekhak on 8/26/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "HighScoreViewController.h"

@interface HighScoreViewController()

@property Manager* manager;

@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;

@end


@implementation HighScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.manager = [Manager sharedInstance];
    
    self.highScoreLabel.text = [NSString stringWithFormat:@"%li", (long)self.manager.bestScore];
}

@end
