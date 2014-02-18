//
//  BCPoint.h
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCPoint : NSObject

@property (nonatomic) GLKVector2 position;

- (float)hitSquareDistance:(GLKVector2)point;

@end
