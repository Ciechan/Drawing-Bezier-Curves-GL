//
//  BCPoint.m
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import "BCPoint.h"

@implementation BCPoint

- (float)hitSquareDistance:(GLKVector2)point
{
    GLKVector2 diff = GLKVector2Subtract(_position, point);
    return GLKVector2DotProduct(diff, diff);
}

@end
