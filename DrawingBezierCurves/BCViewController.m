//
//  BCViewController.m
//  DrawingBezierCurves
//
//  Created by Bartosz Ciechanowski on 15.02.2014.
//  Copyright (c) 2014 Bartosz Ciechanowski. All rights reserved.
//

#import "BCViewController.h"

#import "BCLineShader.h"
#import "BCLineMeshController.h"

#import "BCPointShader.h"
#import "BCPointMeshController.h"

#import "BCLine.h"
#import "BCPoint.h"

#import "BCPointSprite.h"

#import <OpenGLES/ES2/glext.h>

@interface BCViewController ()

@property (nonatomic, strong) EAGLContext *context;

@property (nonatomic, strong) BCLineShader *lineShader;
@property (nonatomic, strong) BCPointShader *pointShader;
@property (nonatomic, strong) GLKTextureInfo *spritesTexture;

@property (nonatomic, strong) BCLineMeshController *lineMeshController;
@property (nonatomic, strong) BCPointMeshController *pointMeshController;

@property (nonatomic, strong) BCLine *line;
@property (nonatomic, strong) NSArray *pointSprites;

@property (nonatomic, strong) BCPoint *draggedPoint;
@property (nonatomic) CGPoint previousTouchLocation;

@end

@implementation BCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    self.preferredFramesPerSecond = 60;
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableMultisample = GLKViewDrawableMultisample4X;
    
    [self setupGL];
    
    self.line = [BCLine new];
    
    [self.line.controlPoints enumerateObjectsUsingBlock:^(BCPoint *point, NSUInteger i, BOOL *stop) {
        point.position = GLKVector2Make((i + 1) * self.view.bounds.size.width/5,
                                        (((((int)i + 1) % 3) - 1) * 0.25 + 0.5) * self.view.bounds.size.height);
    }];
    
    self.pointSprites = @[
                          [[BCPointSprite alloc] initWithType:PointSpriteTypeEndPoint],
                          [[BCPointSprite alloc] initWithType:PointSpriteTypeLeftControl],
                          [[BCPointSprite alloc] initWithType:PointSpriteTypeRightControl],
                          [[BCPointSprite alloc] initWithType:PointSpriteTypeEndPoint]
                          ];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
}


- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self createMeshControllers];
    [self createTexture];
    [self createShaders];
    
    glClearColor(0.93f, 0.93f, 0.93f, 1.0f);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}


- (void)createMeshControllers
{
    self.lineMeshController = [BCLineMeshController new];
    self.lineMeshController.lineSize = 5.0;
    [self.lineMeshController setupOpenGL];
    
    self.pointMeshController = [BCPointMeshController new];
    self.pointMeshController.pointSize = 32.0;
    [self.pointMeshController setupOpenGL];
}

- (void)createShaders
{
    // flipping OpenGL y axis in matrix transform to match UIKit coordinates
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.bounds.size.width, self.view.bounds.size.height, 0, -1.0, 1.0);
    
    self.lineShader = [BCLineShader new];
    [self.lineShader loadProgram];
    
    glUseProgram(self.lineShader.program);
    glUniformMatrix4fv(self.lineShader.viewProjectionMatrixUniform, 1, 0, projectionMatrix.m);
    
    
    self.pointShader = [BCPointShader new];
    [self.pointShader loadProgram];
    
    glUseProgram(self.pointShader.program);
    glUniform1i(self.pointShader.texSamplerUniform, 0);
    glUniformMatrix4fv(self.pointShader.viewProjectionMatrixUniform, 1, 0, projectionMatrix.m);
}

- (void)createTexture
{
    NSError *error;
    self.spritesTexture = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sprites" ofType:@"png"]
                                                              options:nil
                                                                error:&error];
    
    glBindTexture(GL_TEXTURE_2D, self.spritesTexture.name);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [self.lineMeshController updateBuffersWithLineSubdivider:self.line.subdivider segmentsCount:self.line.subdivisionSegments];
    
    [self.line.controlPoints enumerateObjectsUsingBlock:^(BCPoint *point, NSUInteger idx, BOOL *stop) {
        
        BCPointSprite *sprite = self.pointSprites[idx];
        sprite.position = point.position;
    }];
    
    [self.pointMeshController updateBuffersWithPointSprites:self.pointSprites];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);

    glBindVertexArrayOES(self.lineMeshController.VAO);
    
    glDisable(GL_DEPTH_TEST);
    glDepthMask(GL_FALSE);

    glUseProgram(self.lineShader.program);
    glDrawElements(GL_TRIANGLES, self.lineMeshController.indiciesCount, GL_UNSIGNED_SHORT, 0);
    
    glEnable(GL_BLEND);
    
    glBindVertexArrayOES(self.pointMeshController.VAO);

    glUseProgram(self.pointShader.program);
    glDrawElements(GL_TRIANGLES, self.pointMeshController.indiciesCount, GL_UNSIGNED_SHORT, 0);

    glDisable(GL_BLEND);
        
    glBindVertexArrayOES(0);
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self.view];

    self.draggedPoint = [self closestPointToLocation:location];
    self.previousTouchLocation = location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self.view];
    
    GLKVector2 newPosition = GLKVector2Add(self.draggedPoint.position,
                                           GLKVector2Make(location.x - self.previousTouchLocation.x,
                                                          location.y - self.previousTouchLocation.y));

    CGFloat pointSize = self.pointMeshController.pointSize;
    CGSize size = self.view.bounds.size;
    
    GLKVector2 clampedPosition = GLKVector2Make(MIN(MAX(pointSize, newPosition.x), size.width - pointSize),
                                                MIN(MAX(pointSize, newPosition.y), size.height - pointSize));
    
    self.draggedPoint.position = clampedPosition;
    self.previousTouchLocation = location;
}

- (BCPoint *)closestPointToLocation:(CGPoint)location
{
    GLKVector2 position = GLKVector2Make(location.x, location.y);
    
    float bestDistanceSq = INFINITY;
    BCPoint *bestPoint = nil;
    
    for (BCPoint *point in self.line.controlPoints) {
        float distanceSq = [point hitSquareDistance:position];
        if (distanceSq < bestDistanceSq) {
            bestPoint = point;
            bestDistanceSq = distanceSq;
        }
    }
    
    return bestDistanceSq < self.pointMeshController.pointSize * self.pointMeshController.pointSize ? bestPoint : nil;
}

@end
