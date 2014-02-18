//
//  BCPointSprite.h
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, PointSpriteType) {
    PointSpriteTypeEndPoint,
    PointSpriteTypeLeftControl,
    PointSpriteTypeRightControl
};


@interface BCPointSprite : NSObject

@property (nonatomic) GLKVector2 position;
@property (nonatomic, readonly) PointSpriteType type;

- (id)initWithType:(PointSpriteType)type;

@end
