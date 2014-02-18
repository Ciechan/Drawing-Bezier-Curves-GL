//
//  BCShader.h
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    VertexAttribPosition,
    VertexAttribNormal,
    VertexAttribColor,
    VertexAttribTexCoord,
    VertexAttribAlpha,
} VertexAttrib;

@interface BCShader : NSObject

@property (nonatomic, readonly) GLuint program;

- (BOOL)loadProgram;

@end
