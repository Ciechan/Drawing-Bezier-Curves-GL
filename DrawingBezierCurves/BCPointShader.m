//
//  BCPointShader.m
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.08.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import "BCPointShader.h"

@implementation BCPointShader

- (void)bindAttributeLocations
{
    glBindAttribLocation(self.program, VertexAttribPosition, "position");
    glBindAttribLocation(self.program, VertexAttribTexCoord, "texCoord");
}

- (void)getUniformLocations
{
    self.viewProjectionMatrixUniform = glGetUniformLocation(self.program, "viewProjectionMatrix");
    self.texSamplerUniform = glGetUniformLocation(self.program, "texSampler");

}

- (NSString *)shaderName
{
    return @"BCPointShader";
}


@end
