//
//  MyScene.m
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Reichart on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import "BreakoutGameScene.h"

static NSString* ballCategoryName = @"ball";
static NSString* paddleCategoryName = @"paddle";
static NSString* blockCategoryName = @"block";
static NSString* blockNodeCategoryName = @"blockNode";


@interface BreakoutGameScene()

@property (nonatomic) BOOL isFingerOnPaddle;

@end


@implementation BreakoutGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        // Use broader background for iPhone 5
        if (self.frame.size.width == 568) {
            background = [SKSpriteNode spriteNodeWithImageNamed:@"bg-568h.png"];
        } else {
            background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
            
        }
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        
        // 1 Create an physics body that borders the screen
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody;
        // 3 Set the friction of that physicsBody to 0
        self.physicsBody.friction = 0.0f;
        
        // 1
        SKSpriteNode* ball = [SKSpriteNode spriteNodeWithImageNamed: @"ball.png"];
        ball.name = ballCategoryName;
        ball.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
        [self addChild:ball];
        
        // 2
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
        // 3
        ball.physicsBody.friction = 0.0f;
        // 4
        ball.physicsBody.restitution = 1.0f;
        // 5
        ball.physicsBody.linearDamping = 0.0f;
        // 6
        ball.physicsBody.allowsRotation = NO;
        
        [ball.physicsBody applyImpulse:CGVectorMake(10.0f, -10.0f)];
        
        SKSpriteNode* paddle = [[SKSpriteNode alloc] initWithImageNamed: @"paddle.png"];
        paddle.name = paddleCategoryName;
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 0.6f);
        [self addChild:paddle];
        paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
        paddle.physicsBody.restitution = 0.1f;
        paddle.physicsBody.friction = 0.4f;
        // make physicsBody static
        paddle.physicsBody.dynamic = NO;
    }
    return self;
}

@end
