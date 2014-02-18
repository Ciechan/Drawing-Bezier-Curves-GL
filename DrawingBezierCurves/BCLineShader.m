//
//  LineShader.m
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import "BCLineShader.h"

@implementation BCLineShader

- (void)bindAttributeLocations
{
    glBindAttribLocation(self.program, VertexAttribPosition, "position");
}

- (void)getUniformLocations
{
    self.viewProjectionMatrixUniform = glGetUniformLocation(self.program, "viewProjectionMatrix");
}

- (NSString *)shaderName
{
    return @"BCLineShader";
}


@end
