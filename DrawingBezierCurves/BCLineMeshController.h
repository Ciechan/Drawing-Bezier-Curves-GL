//
//  LineController.h
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import "BCMeshController.h"
#import "BCLine.h"

@interface BCLineMeshController : BCMeshController

@property (nonatomic) float lineSize;

- (void)updateBuffersWithLineSubdivider:(SegmentSubdivider)subdivider
                          segmentsCount:(NSUInteger)segmentsCount;

@end
