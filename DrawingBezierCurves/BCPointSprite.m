//
//  BCPointSprite.m
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import "BCPointSprite.h"

@implementation BCPointSprite

- (id)initWithType:(PointSpriteType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

@end
