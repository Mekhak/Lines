//
//  Manager.h
//  1
//
//  Created by Mekhak on 8/17/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantsHeader.h"

@interface Manager : NSObject

@property NSInteger score;

@property NSInteger bestScore;


+ (instancetype)sharedInstance;

- (NSMutableArray*)findShortestWayWithBeginingRow:(NSInteger)beginingRow AndBeginigColumn:(NSInteger)beginingColumn AndEndRow:(NSInteger)endRow AndEndColumn:(NSInteger)endColumn;

- (NSMutableArray*)generateEmptyPositions: (NSInteger)numberOfPositions;

- (NSMutableArray*)checkAndExplodeLinesByRow: (NSInteger)row AndColumn: (NSInteger)column AndColor: (NSInteger)color;

- (void)setEmptyPositionWithRow: (NSInteger)row AndColumn: (NSInteger)column;

- (void)setBisyPositionWithRow: (NSInteger)row AndColumn: (NSInteger)column AndValue: (NSInteger)value;

- (BOOL)isPositionEmptyRow: (NSInteger)row Column: (NSInteger)column;

- (Status)statusOfGame;

- (void)resetManager;

@end
