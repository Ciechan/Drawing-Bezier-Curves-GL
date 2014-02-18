//
//  BCMeshController.h
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCMeshController : NSObject

@property (nonatomic, readonly) GLuint VAO;
@property (nonatomic, readonly) GLuint indiciesCount;

- (void)setupOpenGL;

@end
