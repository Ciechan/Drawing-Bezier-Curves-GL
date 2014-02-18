//
//  BCLine.h
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct SegmentSubdivision {
    GLKVector2 p;
    GLKVector2 n;
} SegmentSubdivision;


typedef SegmentSubdivision (^SegmentSubdivider)(float t);


@interface BCLine : NSObject

@property (nonatomic, strong, readonly) NSArray *controlPoints; // array of BCPoints

- (NSUInteger)subdivisionSegments;
- (SegmentSubdivider)subdivider;

@end
