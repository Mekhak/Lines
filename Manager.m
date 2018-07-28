//
//  Manager.m
//  1
//
//  Created by Mekhak on 8/17/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "Manager.h"

static Manager* sharedInstance = nil;

@interface Manager()

@property NSMutableArray* board;

@property NSMutableArray* emptyPositions;

@property NSMutableArray* myBoard;

@end


@implementation Manager

+ (instancetype)sharedInstance
{
    if(sharedInstance == nil)
        sharedInstance = [[Manager alloc] init];
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _board = [[NSMutableArray alloc] init];
       
        for(int i = 0; i<= BOARD_ROWS - 1; i++)
        {
            [_board addObject:[NSMutableArray array]];
        }
        
        _myBoard = [[NSMutableArray alloc] init];
        
        for(int i = 0; i<= BOARD_ROWS - 1; i++)
        {
            [_myBoard addObject:[NSMutableArray array]];
        }
        
        //init myboard with zeros
        for(NSMutableArray* array in _myBoard)
            for(int i = 1; i <= BOARD_COLUMNS; i++)
                [array addObject:@0];
        
    
        _emptyPositions = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
        
        //init board and emptyPositions
        for(NSInteger i = 0; i <= BOARD_ROWS - 1; i++)
            for(NSInteger j = 0; j <= BOARD_COLUMNS - 1; j++)
            {
                [_board[i] addObject:@0];
                [self.emptyPositions[0] addObject:[NSNumber numberWithInteger:i]];
                [self.emptyPositions[1] addObject:[NSNumber numberWithInteger:j]];
            }
        
        _score = 0;
        _bestScore = 0;
    }
    return self;
}




- (NSMutableArray*)findShortestWayWithBeginingRow:(NSInteger)beginingRow AndBeginigColumn:(NSInteger)beginingColumn AndEndRow:(NSInteger)endRow AndEndColumn:(NSInteger)endColumn

{
    //fill myBoard with correspondese values
    for(int i = 0; i <= BOARD_ROWS - 1; i++)
        for(int j = 0; j <= BOARD_COLUMNS - 1; j++)
        {
            if(([self.board[i][j] isEqualToNumber:[NSNumber numberWithInt: BOARDS_EMPTY_POS_VALUE]]))
            {
                self.myBoard[i][j] = @0;
            }
            else
            {
                self.myBoard[i][j] = [NSNumber numberWithInt:MYBOARD_BUSY_POS_VAL];
            }
        }
    
    //for preserving current positions
     NSMutableArray* matrix1 = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
    
    //add begining values(beginingRow and beginingColumn) in matrix1
    [matrix1[0] addObject:[NSNumber numberWithInteger:beginingRow]];
    [matrix1[1] addObject:[NSNumber numberWithInteger:beginingColumn]];
    
    //for preserving next positions
    NSMutableArray* matrix2 = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
    
    NSMutableArray* road = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
    
    //value for myBoard
    int value = 0;
    BOOL isNotFound = TRUE;
    
    while(isNotFound)
    {
        for(NSInteger k = 0; k <= ([matrix1[0] count]) - 1 && isNotFound; k++)
        {
            NSInteger currentRow = [matrix1[0][k] integerValue];
            NSInteger currentColumn = [matrix1[1][k] integerValue];
            
            for(NSInteger i = currentRow - 1; i <= currentRow + 1 && isNotFound; i++)
            {
                if(i < 0 || i == BOARD_ROWS)//if out of the boards ranges
                    continue;
                else
                    for(NSInteger j = currentColumn - 1; j <= currentColumn + 1 && isNotFound; j++)
                    {
                        if(j < 0 || j >= BOARD_COLUMNS)//if out of the boards ranges
                            continue;
                        if(i == currentRow - 1 && (j == currentColumn - 1 || j == currentColumn + 1))
                            continue;
                        if(i == currentRow && j == currentColumn)
                            continue;
                        if(i == currentRow + 1 && (j == currentColumn - 1 || j == currentColumn + 1))
                            continue;
                        else if(i == endRow && j == endColumn)
                        {
                            isNotFound = 0;
                        }
                        else if([self.myBoard[i][j] isEqualToNumber:[NSNumber numberWithInt:MYBOARD_EMPTY_POS_VAL]])
                        {
                            self.myBoard[i][j] = [NSNumber numberWithInteger:value + 1];
                            [matrix2[0] addObject:[NSNumber numberWithInteger:i]];
                            [matrix2[1] addObject:[NSNumber numberWithInteger:j]];
                        }
                    }
            }
        }
        
        if(isNotFound)
        {
            if(![matrix2[0] count]) //if there arn't empty positions
                return nil;
            else
            {
                value++;
                matrix1[0] = matrix2[0];
                matrix1[1] = matrix2[1];
                matrix2[0] = [NSMutableArray array];
                matrix2[1] = [NSMutableArray array];
            }
        }
    }
    
    // move back and collect road
    NSInteger currentRow = endRow;
    NSInteger currentColumn = endColumn;
    
    for(int i = 0; i<= value; i++)
    {
        [road[0] addObject:[NSNumber numberWithInt:0]];
        [road[1] addObject:[NSNumber numberWithInt:0]];
    }
    
    [road[0] setObject:[NSNumber numberWithInteger:endRow] atIndex:value];
    [road[1] setObject:[NSNumber numberWithInteger:endColumn] atIndex:value];
    
    BOOL startIsNotFound;
    while(value != 0)
    {
        startIsNotFound = TRUE;
        for(NSInteger i = currentRow - 1; i <= currentRow + 1 && startIsNotFound; i++)
        {
            if(i < 0 || i == BOARD_ROWS)
                continue;
            else
                for(NSInteger j = currentColumn - 1; j <= currentColumn + 1 && startIsNotFound; j++)
                {
                    if(j < 0 || j >= BOARD_COLUMNS)
                        continue;
                    if(i == currentRow - 1 && (j == currentColumn - 1 || j == currentColumn + 1))
                        continue;
                    if(i == currentRow && j == currentColumn)
                        continue;
                    if(i == currentRow + 1 && (j == currentColumn - 1 || j == currentColumn + 1))
                        continue;
                    else if([self.myBoard[i][j] isEqualToNumber:[NSNumber numberWithInt:value]])
                    {
                        [road[0] setObject:[NSNumber numberWithInteger:i] atIndex:value - 1];
                        [road[1] setObject:[NSNumber numberWithInteger:j] atIndex:value - 1];
                        value--;
                        currentRow = i;
                        currentColumn = j;
                        startIsNotFound = FALSE;
                    }
                }
        }
    }
    //delete from _emptyPositions
    [self findAndDeletePositionFromEmptyPositionsRow:endRow andColumn:endColumn];
    
    //add to _emptyPositions
    [self.emptyPositions[0] addObject:[NSNumber numberWithInteger:beginingRow]];
    [self.emptyPositions[1] addObject:[NSNumber numberWithInteger:beginingColumn]];
    
    return road;
}


- (NSMutableArray*)generateEmptyPositions: (NSInteger)numberOfPositions
{
    NSMutableArray* generatedPositions = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
    
    srand((unsigned)time(NULL));
    
    for(int i = 1; i <= numberOfPositions; i++)
    {
        if([self.emptyPositions[0] count] <= 0)
            break;
        NSInteger randomPosintion = rand() % [self.emptyPositions[0] count];
        [generatedPositions[0] addObject:self.emptyPositions[0][randomPosintion]];
        [generatedPositions[1] addObject:self.emptyPositions[1][randomPosintion]];
        
        [self.emptyPositions[0] removeObjectAtIndex:randomPosintion];
        [self.emptyPositions[1] removeObjectAtIndex:randomPosintion];
    }
    return generatedPositions;    
}


- (NSMutableArray*)checkAndExplodeLinesByRow: (NSInteger)row AndColumn: (NSInteger)column AndColor: (NSInteger)color
{
    NSMutableArray* lineForExploding = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
    [lineForExploding[0] addObject:[NSNumber numberWithInteger:row]];
    [lineForExploding[1] addObject:[NSNumber numberWithInteger:column]];

    NSMutableArray* tempArray = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
    
    //same horizontal
    NSInteger sameHorizontals = 1;
    NSInteger currentRow = row;
    NSInteger currentColumn = column - 1;
    
    while(currentColumn >= 0)  //  ...X
    {
        if([self.board[currentRow][currentColumn]integerValue] == color)
        {
            sameHorizontals++;
            [tempArray[0] addObject:[NSNumber numberWithInteger:currentRow]];
            [tempArray[1] addObject:[NSNumber numberWithInteger:currentColumn]];
            currentColumn--;
        }
        else
            break;
    }
    
    currentRow = row;
    currentColumn = column + 1;
    
    while(currentColumn <= BOARD_COLUMNS - 1) // X...
    {
        if([self.board[currentRow][currentColumn]integerValue] == color)
        {
            sameHorizontals++;
            [tempArray[0] addObject:[NSNumber numberWithInteger:currentRow]];
            [tempArray[1] addObject:[NSNumber numberWithInteger:currentColumn]];
            currentColumn++;
        }
        else
            break;
    }
    
   
    if(sameHorizontals >= MINIMAL_EXPLODE)
    {
        NSInteger count = [tempArray[0] count];
        for (NSInteger i = 0; i <= count - 1; i++)
        {
            [lineForExploding[0] addObject:tempArray[0][i]];
            [lineForExploding[1] addObject:tempArray[1][i]];
        }
    }
    
    tempArray[0] = [NSMutableArray array];
    tempArray[1] = [NSMutableArray array];
    
    
    //same vertical
    NSInteger sameVerticals = 1;
    currentRow = row - 1;
    currentColumn = column;
    
    while(currentRow >= 0)   //UP
    {
        if([self.board[currentRow][currentColumn]integerValue] == color)
        {
            sameVerticals++;
            [tempArray[0] addObject:[NSNumber numberWithInteger:currentRow]];
            [tempArray[1] addObject:[NSNumber numberWithInteger:currentColumn]];
            currentRow--;
        }
        else
            break;
    }

    currentRow = row + 1;
    currentColumn = column;
    
    while(currentRow <= BOARD_ROWS - 1) //DOWN
    {
        if([self.board[currentRow][currentColumn]integerValue] == color)
        {
            sameVerticals++;
            [tempArray[0] addObject:[NSNumber numberWithInteger:currentRow]];
            [tempArray[1] addObject:[NSNumber numberWithInteger:currentColumn]];
            currentRow++;
        }
        else
            break;
    }
    
    
    if(sameVerticals >= MINIMAL_EXPLODE)
    {
        NSInteger count = [tempArray[0] count];
        for (NSInteger i = 0; i <= count- 1; i++)
        {
            [lineForExploding[0] addObject:tempArray[0][i]];
            [lineForExploding[1] addObject:tempArray[1][i]];
        }
    }
    tempArray[0] = [NSMutableArray array];
    tempArray[1] = [NSMutableArray array];
    
    
    //main diaganal
    NSInteger inTheSameMainDiaganal = 1;
    currentRow = row - 1;
    currentColumn = column - 1;
    
    while(currentRow >= 0 && currentColumn >= 0)   //main diaganal
    {
        if([self.board[currentRow][currentColumn]integerValue] == color)
        {
            inTheSameMainDiaganal++;
            [tempArray[0] addObject:[NSNumber numberWithInteger:currentRow]];
            [tempArray[1] addObject:[NSNumber numberWithInteger:currentColumn]];
            currentRow--;
            currentColumn--;
        }
        else
            break;
    }
    
    currentRow = row + 1;
    currentColumn = column + 1;
    
    while(currentRow <= BOARD_ROWS - 1 && currentColumn <= BOARD_COLUMNS - 1)
    {
        if([self.board[currentRow][currentColumn]integerValue] == color)
        {
            inTheSameMainDiaganal++;
            [tempArray[0] addObject:[NSNumber numberWithInteger:currentRow]];
            [tempArray[1] addObject:[NSNumber numberWithInteger:currentColumn]];
            currentRow++;
            currentColumn++;
        }
        else
            break;
    }
    
    if(inTheSameMainDiaganal >= MINIMAL_EXPLODE)
    {
        NSInteger count = [tempArray[0] count];
        for (NSInteger i = 0; i <= count - 1; i++)
        {
            [lineForExploding[0] addObject:tempArray[0][i]];
            [lineForExploding[1] addObject:tempArray[1][i]];
        }
    }
    tempArray[0] = [NSMutableArray array];
    tempArray[1] = [NSMutableArray array];
    
    
    //secondary diaganal
    NSInteger inTheSameSecondaryDiaganal = 1;
    currentRow = row + 1;
    currentColumn = column - 1;
    
    while(currentRow <= BOARD_ROWS - 1 && currentColumn >= 0)
    {
        if([self.board[currentRow][currentColumn]integerValue] == color)
        {
            inTheSameSecondaryDiaganal++;
            [tempArray[0] addObject:[NSNumber numberWithInteger:currentRow]];
            [tempArray[1] addObject:[NSNumber numberWithInteger:currentColumn]];
            currentRow++;
            currentColumn--;
        }
        else
            break;
    }
    
    
    currentRow = row - 1;
    currentColumn = column + 1;
    
    while(currentRow >= 0 && currentColumn <= BOARD_COLUMNS - 1)
    {
        if([self.board[currentRow][currentColumn]integerValue] == color)
        {
            inTheSameSecondaryDiaganal++;
            [tempArray[0] addObject:[NSNumber numberWithInteger:currentRow]];
            [tempArray[1] addObject:[NSNumber numberWithInteger:currentColumn]];
            currentRow--;
            currentColumn++;
        }
        else
            break;
    }
    
    if(inTheSameSecondaryDiaganal >= MINIMAL_EXPLODE)
    {
        NSInteger count = [tempArray[0] count];
        for (NSInteger i = 0; i <= count - 1; i++)
        {
            [lineForExploding[0] addObject:tempArray[0][i]];
            [lineForExploding[1] addObject:tempArray[1][i]];
        }
    }
    
    
    if([lineForExploding[0] count] >= MINIMAL_EXPLODE)
    {
        for(NSInteger i = 0; i <= [lineForExploding[0] count] - 1; i++)
        {
            NSInteger row = [lineForExploding[0][i] integerValue];
            NSInteger column = [lineForExploding[1][i] integerValue];
            self.board[row][column] = [NSNumber numberWithInteger:BOARDS_EMPTY_POS_VALUE];
            [self.emptyPositions[0] addObject:[NSNumber numberWithInteger:row]];
            [self.emptyPositions[1] addObject:[NSNumber numberWithInteger:column]];
        }
        
        self.score += [lineForExploding[0] count];
        if(self.score > self.bestScore)
            self.bestScore = self.score;
        
        return lineForExploding;
    }
    else return nil;
}


- (void)setEmptyPositionWithRow: (NSInteger)row AndColumn: (NSInteger)column
{
    self.board[row][column] = [NSNumber numberWithInteger:BOARDS_EMPTY_POS_VALUE];
}

- (void)setBisyPositionWithRow:(NSInteger)row AndColumn:(NSInteger)column AndValue:(NSInteger)value
{
    self.board[row][column] = [NSNumber numberWithInteger:value];
}

- (BOOL)isPositionEmptyRow: (NSInteger)row Column: (NSInteger)column
{
    return [self.board[row][column] integerValue] == BOARDS_EMPTY_POS_VALUE;
}

- (Status)statusOfGame
{
    Status gameStatus = Continue;
    NSInteger emptyPositionsCount = [self.emptyPositions[0] count];
    
    if (emptyPositionsCount == 0)
        gameStatus = Lose;
    else if(emptyPositionsCount == BOARD_ROWS * BOARD_COLUMNS)
        gameStatus = Won;
    else gameStatus = Continue;
    
    return gameStatus;
}

- (void)findAndDeletePositionFromEmptyPositionsRow: (NSInteger)row andColumn: (NSInteger)column
{
    NSInteger index;
    for(NSInteger i = 0; i <= [self.emptyPositions[0] count] - 1; i++)
    {
        if([self.emptyPositions[0][i] integerValue] == row && [self.emptyPositions[1][i] integerValue] == column)
        {
            index = i;
            break;
        }
    }
    [self.emptyPositions[0] removeObjectAtIndex:index];
    [self.emptyPositions[1] removeObjectAtIndex:index];
}

- (void)resetManager
{
    _emptyPositions = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
    for(NSInteger i = 0; i <= BOARD_ROWS - 1; i++)
    {
        for (NSInteger j = 0; j <= BOARD_COLUMNS - 1; j++)
        {
            self.board[i][j] = @0;
            [self.emptyPositions[0] addObject:[NSNumber numberWithInteger:i]];
            [self.emptyPositions[1] addObject:[NSNumber numberWithInteger:j]];
        }
    }
    self.score = 0;
}

@end
