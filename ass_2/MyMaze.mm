//
//  MyMaze.cpp
//  ass_2
//
//  Created by Jason Chung on 2019-03-07.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "MyMaze.h"
#include "maze.h"

struct MazeClass {
    Maze *maze;
};

@implementation MyMaze

- (id)init {
    if (self == [super init]) {
        mazeObject = new MazeClass;
        mazeObject->maze = new Maze(4, 4);
        mazeObject->maze->Create();
    }
    return self;
}

- (int)numCols {
    return mazeObject->maze->cols;
}

- (int)numRows {
    return mazeObject->maze->rows;
}

- (bool)hasNorthWall:(int)row col:(int)col {
    return mazeObject->maze->GetCell(row, col).northWallPresent;
}

- (bool)hasEastWall:(int)row col:(int)col {
    return mazeObject->maze->GetCell(row, col).eastWallPresent;
}

- (bool)hasSouthWall:(int)row col:(int)col {
    return mazeObject->maze->GetCell(row, col).southWallPresent;
}

- (bool)hasWestWall:(int)row col:(int)col {
    return mazeObject->maze->GetCell(row, col).westWallPresent;
}

@end
