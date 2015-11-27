//
//  LineController.m
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import "BCLineMeshController.h"
#import "BCMeshController_Private.h"

#import "BCShader.h"

#import <OpenGLES/ES2/glext.h>

typedef GLKVector2 LineVertex;

static const NSUInteger VertexLimit = USHRT_MAX;
static const NSUInteger IndexLimit = VertexLimit * 4;


static const NSUInteger VerticesInSegment = 2;
static const NSUInteger IndiciesInSegment = 6;


@implementation BCLineMeshController


- (void)setupVAO
{
    glGenVertexArraysOES(1, &_VAO);
    glBindVertexArrayOES(_VAO);
    
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, VertexLimit * sizeof(LineVertex), NULL, GL_DYNAMIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, IndexLimit * sizeof(GLushort), NULL, GL_DYNAMIC_DRAW);
    
    glEnableVertexAttribArray(VertexAttribPosition);
    glVertexAttribPointer(VertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(LineVertex), (void *)0);
    
    glBindVertexArrayOES(0);
}

- (void)updateBuffersWithLineSubdivider:(SegmentSubdivider)subdivider
                          segmentsCount:(NSUInteger)segmentsCount
{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    LineVertex *vertexData = glMapBufferOES(GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    GLushort *indexData = glMapBufferOES(GL_ELEMENT_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
    
    
    GLuint totalIndicies = 0;
    GLuint totalVertices = 0;
    
    {
        NSUInteger verticesCount;
        NSUInteger indiciesCount;
        
        BOOL hasFilledAll = [self generateWithSubdivider:subdivider
                                           segmentsCount:segmentsCount
                                              vertexData:vertexData
                                               indexData:indexData
                                        startVertexIndex:totalVertices
                                           verticesCount:&verticesCount
                                           indiciesCount:&indiciesCount];
        
        if (hasFilledAll) {
            totalIndicies += indiciesCount;
            totalVertices += verticesCount;
            
            vertexData += verticesCount;
            indexData += indiciesCount;
        }
    }
    
    
    _indiciesCount = totalIndicies;
    
    glUnmapBufferOES(GL_ELEMENT_ARRAY_BUFFER);
    glUnmapBufferOES(GL_ARRAY_BUFFER);
}


- (BOOL)generateWithSubdivider:(SegmentSubdivider)subdivider
                 segmentsCount:(NSUInteger)segmentsCount
                    vertexData:(LineVertex *)vertexData
                     indexData:(GLushort *)indexData
              startVertexIndex:(NSUInteger)startVertex
                 verticesCount:(out NSUInteger *)verticesCount
                 indiciesCount:(out NSUInteger *)indiciesCount
{
    LineVertex v[VerticesInSegment];
    GLushort i[IndiciesInSegment];
    
    NSUInteger totalIndicies = 0;
    NSUInteger totalVertices = 0;
    
    
    
    if (startVertex + (segmentsCount + 1) * VerticesInSegment > VertexLimit) {
        return NO;
    }
    
    for (int seg = 0; seg <= segmentsCount; seg++) {
        
        SegmentSubdivision subdivision = subdivider((double)seg/(double)segmentsCount);
        v[0] = GLKVector2Add(subdivision.p, GLKVector2MultiplyScalar(subdivision.n, +_lineSize /2.0f));
        v[1] = GLKVector2Add(subdivision.p, GLKVector2MultiplyScalar(subdivision.n, -_lineSize /2.0f));
        
        memcpy(vertexData, v, sizeof(v));
        vertexData += VerticesInSegment;
        totalVertices += VerticesInSegment;
    }
    
    for (int seg = 0; seg < segmentsCount; seg++) {
        
        i[0] = startVertex + 0;
        i[1] = startVertex + 2;
        i[2] = startVertex + 1;
        
        i[3] = startVertex + 1;
        i[4] = startVertex + 2;
        i[5] = startVertex + 3;
        
        memcpy(indexData, i, sizeof(i));
        indexData += IndiciesInSegment;
        totalIndicies += IndiciesInSegment;
        
        startVertex += VerticesInSegment;
    }
    
    *verticesCount = totalVertices;
    *indiciesCount = totalIndicies;
    
    return YES;
}


@end
