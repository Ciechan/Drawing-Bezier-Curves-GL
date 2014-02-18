//
//  BCMeshController_Private.h
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import "BCMeshController.h"

@interface BCMeshController ()
{
    @protected
    GLuint _VAO;
    GLuint _indiciesCount;
    
    GLuint _indexBuffer;
    GLuint _vertexBuffer;
}

- (void)setupVAO;

@end
