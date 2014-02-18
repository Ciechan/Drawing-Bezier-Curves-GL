//
//  BCPointMeshController.h
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import "BCMeshController.h"

@interface BCPointMeshController : BCMeshController

@property (nonatomic) float pointSize;

- (void)updateBuffersWithPointSprites:(NSArray *)pointSprites;

@end
