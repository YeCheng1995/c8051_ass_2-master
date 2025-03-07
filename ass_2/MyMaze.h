//
//  MyMaze.h
//  ass_2
//
//  Created by Jason Chung on 2019-03-07.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <Foundation/Foundation.h>

struct MazeClass;

@interface MyMaze : NSObject {
    @private
    struct MazeClass *mazeObject;
}

- (int)numCols;
- (int)numRows;
- (bool)hasNorthWall:(int)row col:(int)col;
- (bool)hasEastWall:(int)row col:(int)col;
- (bool)hasSouthWall:(int)row col:(int)col;
- (bool)hasWestWall:(int)row col:(int)col;

@end
