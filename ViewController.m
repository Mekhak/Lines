//
//  ViewController.m
//  Lines
//
//  Created by Mekhak on 8/18/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property NSMutableArray* grid;

@property NSInteger whichTapIs;

@property Manager* manager;

@property NSInteger firstTapRow;
@property NSInteger firstapColumn;

@property NSInteger secondTapRow;
@property NSInteger secondTapColumn;

@property NSMutableArray* ballsWaitingToEnter;

@property NSMutableArray* road;

@property NSInteger variableForTimer;

@property NSInteger indexForRoad;

@property UIColor*  colorToShow;

@property UIAlertController* wonAlert;

@property UIAlertController* loseAlert;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property NSArray* colorsArray;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DURATION target:self selector:@selector(targetForTimer:) userInfo:nil repeats:YES];
    
    self.variableForTimer = -1;
    
    self.indexForRoad = 0;
    
    self.whichTapIs = 1;
    
    self.manager = [Manager sharedInstance];
    
    self.grid = [NSMutableArray array];
    
    for(int i = 0; i <= BOARD_ROWS - 1; i++)
    {
        [self.grid addObject:[NSMutableArray array]];
    }
        
    //create cages
    for(int i = 0; i <= BOARD_ROWS - 1; i++)
    {
        for(int j = 0; j <= BOARD_COLUMNS - 1; j++)
        {
            CageView* cage = [[CageView alloc] initWithFrame: CGRectMake(j * CAGE_WIDTH, BOARD_ORIGIN_Y + i * CAGE_HEIGHT, CAGE_WIDTH, CAGE_HEIGHT)];
            cage.tag = i * BOARD_COLUMNS + j;
            cage.alpha = .9;
            [self.view addSubview:cage];
            cage.delegate = self;
            self.grid[i][j] = cage;
        }
    }

    
    //create alerts
    self.wonAlert = [UIAlertController alertControllerWithTitle:@"You Won!!!" message:@"Restart or Quit" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionForRestart = [UIAlertAction actionWithTitle:@"Restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                                       {
                                           [self restartButtonAction:nil];
                                       }];
    
    UIAlertAction* actionForQuit = [UIAlertAction actionWithTitle:@"Quit" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action)
                                    {
                                        [self quitButtonAction:nil];
                                    }];
    [self.wonAlert addAction:actionForRestart];
    [self.wonAlert addAction:actionForQuit];
    
    self.loseAlert = [UIAlertController alertControllerWithTitle:@"You Lose!!!" message:@"Restart or Quit" preferredStyle:UIAlertControllerStyleAlert];
    
    [self.loseAlert addAction:actionForRestart];
    [self.loseAlert addAction:actionForQuit];

    //create colors array
    self.colorsArray = [NSArray arrayWithObjects:[UIColor blackColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor],[UIColor whiteColor], nil];
    
    //array for waiting balls
    self.ballsWaitingToEnter = [NSMutableArray array];
    
    //create waiting balls
    for(NSInteger i = 0; i <= NEW_BALLS_COUNT - 1; i++)
    {
        BallView* ball = [[BallView alloc]initWithFrame:CGRectMake(i * WAITING_BALL_FRAME_SIZE + 10, WAITING_BALLS_ORIGIN_Y, WAITING_BALL_FRAME_SIZE, WAITING_BALL_FRAME_SIZE)];
        [self.ballsWaitingToEnter addObject:ball];
        [self.view addSubview:ball];
        ball.backgroundColor = [self generateUIColor];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //show waiting balls
    [self addNewBalls];
}


- (void)cageViewTapped:(CageView *)view
{
    NSInteger tappedRow = view.tag / BOARD_COLUMNS;
    NSInteger tappedColumn = view.tag % BOARD_COLUMNS;
    
    if(self.indexForRoad == 0 && self.whichTapIs == 1 && ![self.manager isPositionEmptyRow:tappedRow Column:tappedColumn])
    {
        //first tap
        view.backgroundColor = CAGE_COLOR_WHEN_TAPPED;
        self.firstTapRow = tappedRow;
        self.firstapColumn = tappedColumn;
        self.whichTapIs = 2;
    }
    
    else if(self.whichTapIs == 2 && ![self.manager isPositionEmptyRow:tappedRow Column:tappedColumn])
    {
        [self.grid[self.firstTapRow][self.firstapColumn] setBackgroundColor:CAGE_COLOR];
        view.backgroundColor = CAGE_COLOR_WHEN_TAPPED;
        self.firstTapRow = tappedRow;
        self.firstapColumn = tappedColumn;
    }
    else  if(self.whichTapIs == 2 && [self.manager isPositionEmptyRow:tappedRow Column:tappedColumn])
    {
        //second tap
        self.secondTapRow = tappedRow;
        self.secondTapColumn = tappedColumn;
        
        self.road = [self.manager findShortestWayWithBeginingRow:self.firstTapRow AndBeginigColumn:self.firstapColumn AndEndRow:self.secondTapRow AndEndColumn:self.secondTapColumn];
        if(self.road)
        {
            self.variableForTimer = 0;
            [self.manager setEmptyPositionWithRow:self.firstTapRow AndColumn:self.firstapColumn];
            [self.grid[self.firstTapRow][self.firstapColumn] ball].hidden = YES;
            [self.grid[self.firstTapRow][self.firstapColumn] setBackgroundColor:CAGE_COLOR];
            
            self.colorToShow = [self.grid[self.firstTapRow][self.firstapColumn] ball].backgroundColor;
            
            [self.grid[self.secondTapRow][self.secondTapColumn] ball].backgroundColor = self.colorToShow;
         
            NSInteger integerValueForColor = [self.colorsArray indexOfObject:self.colorToShow];
            [self.manager setBisyPositionWithRow:self.secondTapRow AndColumn:self.secondTapColumn AndValue:integerValueForColor];
            
            self.whichTapIs = 1;
        }
    }
}



- (void)targetForTimer:(NSTimer*)timer
{
    if(self.variableForTimer != -1)
    {
        if(self.indexForRoad <= [self.road[0] count] - 1)
        {
            if(self.indexForRoad > 0)
            {
                NSInteger previousRow = [self.road[0][self.indexForRoad - 1] integerValue];
                NSInteger previousColumn = [self.road[1][self.indexForRoad - 1] integerValue];
                [self.grid[previousRow][previousColumn] ball].hidden = YES;
            }
            
            NSInteger currentRow = [self.road[0][self.indexForRoad] integerValue];
            NSInteger currentColumn = [self.road[1][self.indexForRoad] integerValue];
            [self.grid[currentRow][currentColumn] ball].hidden = NO;
            [self.grid[currentRow][currentColumn] ball].backgroundColor = self.colorToShow;
            self.indexForRoad++;
        }
        else
        {
            self.variableForTimer = -1;
            self.indexForRoad = 0;
            
            NSInteger integerValueForColor = [self.colorsArray indexOfObject:self.colorToShow];
            if(![self checkForBumpWithRow:self.secondTapRow AndColumn:self.secondTapColumn AndColor:integerValueForColor])
            {
                [self addNewBalls];
            }
            else if ([self.manager statusOfGame] == Won)
            {
                [self presentViewController:self.wonAlert animated:YES completion:nil];
            }
        }
    }
}



- (void)addNewBalls
{
    NSMutableArray* newBallsPositionsMatrix = [self.manager generateEmptyPositions:NEW_BALLS_COUNT];
    
    BOOL alertWasApeared = NO;
    
    for (NSInteger i = 0; i <= [newBallsPositionsMatrix[0] count] - 1 && !alertWasApeared; i++)
    {
        NSInteger row = [newBallsPositionsMatrix[0][i] integerValue];
        NSInteger column = [newBallsPositionsMatrix[1][i] integerValue];
        
        UIColor* uiColor = [self.ballsWaitingToEnter[i] backgroundColor];
        [self.grid[row][column] ball].backgroundColor = uiColor;
        
        NSInteger integerForUIColor = [self.colorsArray indexOfObject:uiColor];
        [self.manager setBisyPositionWithRow:row AndColumn:column AndValue:integerForUIColor];
        [self.grid[row][column] ball].hidden = NO;
        
        [self checkForBumpWithRow:row AndColumn:column AndColor:integerForUIColor];
        
        if ([self.manager statusOfGame] == Won)
        {
            [self presentViewController:self.wonAlert animated:YES completion:nil];
            alertWasApeared = YES;
        }
        else if([self.manager statusOfGame] == Lose)
        {
            [self presentViewController:self.loseAlert animated:YES completion:nil];
            alertWasApeared = YES;
        }
    }
    [self setWaitingBallsColors];    
}



- (BOOL)checkForBumpWithRow: (NSInteger)row AndColumn: (NSInteger)column AndColor: (NSInteger)color
{
    NSMutableArray* positionsForBumpMatrix = [self.manager checkAndExplodeLinesByRow:row AndColumn:column AndColor:color];
    
    if(positionsForBumpMatrix)
    {
        for(NSInteger i = 0; i <= [positionsForBumpMatrix[0] count] - 1; i++)
        {
            NSInteger row = [positionsForBumpMatrix[0][i] integerValue];
            NSInteger column = [positionsForBumpMatrix[1][i] integerValue];
            [self.grid[row][column] ball].hidden = YES;
        }
        self.scoreLabel.text = [NSString stringWithFormat:@"%li",(long)self.manager.score];
        return YES;
    }    
    return NO;
}


- (UIColor*)generateUIColor
{
    NSInteger colorNumber = 1 + (arc4random() % COLORS_COUNT);
    return self.colorsArray[colorNumber];
}

- (void)setWaitingBallsColors
{
    for(NSInteger i = 0; i <= NEW_BALLS_COUNT - 1; i++)
    {
        [_ballsWaitingToEnter[i] setBackgroundColor:[self generateUIColor]];
    }
}

- (IBAction)restartButtonAction:(id)sender
{
    self.scoreLabel.text = @"0";
    
    [self.manager resetManager];
    
    for(NSInteger i = 0; i <= BOARD_ROWS - 1; i++)
    {
        for(NSInteger j = 0; j <= BOARD_COLUMNS - 1; j++)
            [self.grid[i][j] ball].hidden = YES;
    }
    [self addNewBalls];
}

- (IBAction)quitButtonAction:(UIButton *)sender
{
    [self.manager resetManager];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
