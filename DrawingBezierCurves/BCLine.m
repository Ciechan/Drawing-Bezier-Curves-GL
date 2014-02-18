//
//  BCLine.m
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import "BCLine.h"
#import "BCPoint.h"


@interface BCLine()
{
    BCPoint *_points[4];
}

@end

@implementation BCLine

- (id)init
{
    self = [super init];
    if (self) {
        for (int i = 0; i < 4; i++) {
            _points[i] = [BCPoint new];
        }
        
        _controlPoints = @[_points[0], _points[1], _points[2], _points[3]];
    }
    return self;
}

- (NSUInteger)subdivisionSegments
{
    float segments = [self approxLength]/20.0f;
    
    return ceilf(sqrt(segments * segments * 0.6 + 225.0));
}



- (NSUInteger)approxLength
{
    GLKVector2 a = _points[0].position;
    GLKVector2 p1 = _points[1].position;
    GLKVector2 p2 = _points[2].position;
    GLKVector2 b = _points[3].position;

    float length = (GLKVector2Length(GLKVector2Subtract(a, p1)) +
                    GLKVector2Length(GLKVector2Subtract(p1, p2)) +
                    GLKVector2Length(GLKVector2Subtract(p2, b)));
    
    return length;
}


- (SegmentSubdivider)subdivider
{
    GLKVector2 a = _points[0].position;
    GLKVector2 p1 = _points[1].position;
    GLKVector2 p2 = _points[2].position;
    GLKVector2 b = _points[3].position;

    return ^(float t){
        float nt = 1.0f - t;
        
        SegmentSubdivision subdivision;
        subdivision.p = GLKVector2Make(a.x * nt * nt * nt  +  3.0 * p1.x * nt * nt * t  +  3.0 * p2.x * nt * t * t  +  b.x * t * t * t,
                                       a.y * nt * nt * nt  +  3.0 * p1.y * nt * nt * t  +  3.0 * p2.y * nt * t * t  +  b.y * t * t * t);
        
        GLKVector2 tangent = GLKVector2Make(-3.0 * a.x * nt * nt  +  3.0 * p1.x * (1.0 - 4.0 * t + 3.0 * t * t)  +  3.0 * p2.x * (2.0 * t - 3.0 * t * t)  +  3.0 * b.x * t * t,
                                            -3.0 * a.y * nt * nt  +  3.0 * p1.y * (1.0 - 4.0 * t + 3.0 * t * t)  +  3.0 * p2.y * (2.0 * t - 3.0 * t * t)  +  3.0 * b.y * t * t);
        
        subdivision.n = GLKVector2Normalize(GLKVector2Make(-tangent.y, tangent.x));
        
        return subdivision;
    };
}


@end
