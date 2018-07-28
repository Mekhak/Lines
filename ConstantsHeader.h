//
//  ConstantsHeader.h
//  Lines
//
//  Created by Mekhak on 8/21/16.
//  Copyright © 2016 Mekhak. All rights reserved.
//

#ifndef ConstantsHeader_h
#define ConstantsHeader_h


#define BOARD_ORIGIN_X 0
#define BOARD_ORIGIN_Y  150
#define EMPTY_SPACE 50
#define CAGE_WIDTH self.view.frame.size.width / BOARD_COLUMNS
#define CAGE_HEIGHT (self.view.frame.size.height - BOARD_ORIGIN_Y - EMPTY_SPACE) / BOARD_ROWS

#define BOARD_ROWS 8
#define BOARD_COLUMNS 8
#define MINIMAL_EXPLODE 3
#define NEW_BALLS_COUNT 3
#define COLORS_COUNT 9

#define ANIMATION_DURATION 0.05

#define BOARDS_EMPTY_POS_VALUE 0
#define MYBOARD_EMPTY_POS_VAL 0
#define MYBOARD_BUSY_POS_VAL -1
#define WAITING_BALLS_ORIGIN_X 0
#define WAITING_BALLS_ORIGIN_Y  2 * BOARD_ORIGIN_Y / 3
#define WAITING_BALL_FRAME_SIZE  45
#define CAGE_COLOR [UIColor grayColor]
#define CAGE_COLOR_WHEN_TAPPED [UIColor blackColor]

#define SCORE_WEIGHT 100

#define COLOR_RED 1
#define COLOR_GREEN 2
#define COLOR_BLUE 3
#define COLOR_CYAN 4
#define COLOR_MAGENTA 5
#define COLOR_ORANGE 6
#define COLOR_PURPLE 7
#define COLOR_BROWN 8
#define COLOR_WHITE 9




typedef NS_ENUM(NSInteger, Status)
{
    Won,
    Continue,
    Lose
};
#endif /* ConstantsHeader_h */
