//
//  BCPointMeshController.m
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "BCPointMeshController.h"
#import "BCMeshController_Private.h"
#import "BCShader.h"

#import "BCPointSprite.h"

#import <OpenGLES/ES2/glext.h>

typedef struct PointVertex {
    GLKVector2 p;
    GLKVector2 uv;
} PointVertex;

static const NSUInteger VertexLimit = 480;
static const NSUInteger IndexLimit = VertexLimit * 2;


static GLKVector2 PointTexTypeOffset[] = {
    [PointSpriteTypeEndPoint]     = {0.0, 0.0},
    [PointSpriteTypeLeftControl]  = {0.5, 0.0},
    [PointSpriteTypeRightControl] = {0.5, 0.0},
};

static GLKVector2 PointTexEndPos[3][4] = {
    [PointSpriteTypeEndPoint][0]     = {0.5, 1.0},
    [PointSpriteTypeEndPoint][1]     = {0.0, 1.0},
    [PointSpriteTypeEndPoint][2]     = {0.5, 0.0},
    [PointSpriteTypeEndPoint][3]     = {0.0, 0.0},

    [PointSpriteTypeLeftControl][0]  = {0.5, 0.0},
    [PointSpriteTypeLeftControl][1]  = {0.5, 1.0},
    [PointSpriteTypeLeftControl][2]  = {0.0, 0.0},
    [PointSpriteTypeLeftControl][3]  = {0.0, 1.0},
    
    [PointSpriteTypeRightControl][0] = {0.5, 1.0},
    [PointSpriteTypeRightControl][1] = {0.0, 1.0},
    [PointSpriteTypeRightControl][2] = {0.5, 0.0},
    [PointSpriteTypeRightControl][3] = {0.0, 0.0},
    
};

@implementation BCPointMeshController


- (void)setupVAO
{
    glGenVertexArraysOES(1, &_VAO);
    glBindVertexArrayOES(_VAO);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, VertexLimit * sizeof(PointVertex), NULL, GL_DYNAMIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, IndexLimit * sizeof(GLushort), NULL, GL_DYNAMIC_DRAW);
    
    
    glEnableVertexAttribArray(VertexAttribPosition);
    glVertexAttribPointer(VertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(PointVertex), (void *)offsetof(PointVertex, p));
    
    glEnableVertexAttribArray(VertexAttribTexCoord);
    glVertexAttribPointer(VertexAttribTexCoord, 2, GL_FLOAT, GL_FALSE, sizeof(PointVertex), (void *)offsetof(PointVertex, uv));

    
    glBindVertexArrayOES(0);
}


- (void)updateBuffersWithPointSprites:(NSArray *)pointSprites
{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    PointVertex *vertexData = glMapBufferOES(GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    GLushort *indexData = glMapBufferOES(GL_ELEMENT_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
    
    PointVertex v[4];
    GLushort i[6];

    GLuint totalIndicies = 0;
    GLuint totalVertices = 0;
    
    for (BCPointSprite *pointSprite in pointSprites) {
        
        if (totalVertices + 4 > VertexLimit) {
            break;
        }
        
        GLKVector2 offset = PointTexTypeOffset[pointSprite.type];
        GLKVector2 center = pointSprite.position;
        PointSpriteType type = pointSprite.type;
        
        float size = self.pointSize;
        
        v[0].uv = GLKVector2Add(offset, PointTexEndPos[type][0]);
        v[1].uv = GLKVector2Add(offset, PointTexEndPos[type][1]);
        v[2].uv = GLKVector2Add(offset, PointTexEndPos[type][2]);
        v[3].uv = GLKVector2Add(offset, PointTexEndPos[type][3]);
        
        v[0].p = GLKVector2Make(center.x + size, center.y + size);
        v[1].p = GLKVector2Make(center.x - size, center.y + size);
        v[2].p = GLKVector2Make(center.x + size, center.y - size);
        v[3].p = GLKVector2Make(center.x - size, center.y - size);
        
        memcpy(vertexData, v, sizeof(v));
        vertexData += sizeof(v)/sizeof(v[0]);
        
        i[0] = totalVertices + 0;
        i[1] = totalVertices + 2;
        i[2] = totalVertices + 1;
        
        i[3] = totalVertices + 1;
        i[4] = totalVertices + 2;
        i[5] = totalVertices + 3;
        
        memcpy(indexData, i, sizeof(i));
        indexData += sizeof(i)/sizeof(i[0]);
        
        totalIndicies += 6;
        totalVertices += 4;
    }
    
    _indiciesCount = totalIndicies;
    
    glUnmapBufferOES(GL_ELEMENT_ARRAY_BUFFER);
    glUnmapBufferOES(GL_ARRAY_BUFFER);
}



@end
