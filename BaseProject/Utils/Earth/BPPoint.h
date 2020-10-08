//
//  BPPoint.h
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/8.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

#ifndef BPPoint_h
#define BPPoint_h

struct BPPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

typedef struct BPPoint BPPoint;

static BPPoint BPPointMake(CGFloat x, CGFloat y, CGFloat z) {
    BPPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

#endif /* BPPoint_h */
