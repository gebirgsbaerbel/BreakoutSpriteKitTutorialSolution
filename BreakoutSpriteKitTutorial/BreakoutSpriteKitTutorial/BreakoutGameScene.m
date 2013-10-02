//
//  MyScene.m
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Reichart on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import "BreakoutGameScene.h"
#import "GameOverScene.h"

static NSString* ballCategoryName = @"ball";
static NSString* paddleCategoryName = @"paddle";
static NSString* blockCategoryName = @"block";
static NSString* blockNodeCategoryName = @"blockNode";

static const uint32_t ballCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t bottomCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t blockCategory = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t paddleCategory = 0x1 << 3; // 00000000000000000000000000001000


@interface BreakoutGameScene()

@property (nonatomic) BOOL isFingerOnPaddle;

@end


@implementation BreakoutGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
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
        
        CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
        SKNode* bottom = [SKNode node];
        bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
        [self addChild:bottom];
        
        bottom.physicsBody.categoryBitMask = bottomCategory;
        ball.physicsBody.categoryBitMask = ballCategory;
        paddle.physicsBody.categoryBitMask = paddleCategory;
        
        ball.physicsBody.contactTestBitMask = bottomCategory;
        
        self.physicsWorld.contactDelegate = self;
        
        // 1 Store some useful variables
        int numberOfBlocks = 3;
        int blockWidth = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"].size.width;
        float padding = 20.0f;
        // 2 Calculate the xOffset
        float xOffset = (self.frame.size.width - (blockWidth * numberOfBlocks + padding * (numberOfBlocks-1))) / 2;
        // 3 Create the blocks and add them to the scene
        for (int i = 1; i <= numberOfBlocks; i++) {
            SKSpriteNode* block = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"];
            block.position = CGPointMake((i-0.5f)*block.frame.size.width + (i-1)*padding + xOffset, self.frame.size.height * 0.8f);
            block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.frame.size];
            block.physicsBody.allowsRotation = NO;
            block.physicsBody.friction = 0.0f;
            block.name = blockCategoryName;
            block.physicsBody.categoryBitMask = blockCategory;
            [self addChild:block];
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    /* Called when a touch begins */
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:touchLocation];
    if (body && [body.node.name isEqualToString: paddleCategoryName]) {
        NSLog(@"Began touch on paddle");
        self.isFingerOnPaddle = YES;
    }
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // 1 Check whether user tapped paddle
    if (self.isFingerOnPaddle) {
        // 2 Get touch location
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        // 3 Get node for paddle
        SKSpriteNode* paddle = (SKSpriteNode*)[self childNodeWithName: paddleCategoryName];
        // 4 Calculate new position along x for paddle
        int paddleX = paddle.position.x + (touchLocation.x - previousLocation.x);
        // 5 Limit x so that the paddle will not leave the screen to left or right
        paddleX = MAX(paddleX, paddle.size.width/2);
        paddleX = MIN(paddleX, self.size.width - paddle.size.width/2);
        // 6 Update position of paddle
        paddle.position = CGPointMake(paddleX, paddle.position.y);
    }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    self.isFingerOnPaddle = NO;
}

- (void)didBeginContact:(SKPhysicsContact*)contact {
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // 3 react to the contact between ball and bottom
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory) {
        //TODO: Replace the log statement with display of Game Over Scene
        GameOverScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:NO];
        [self.view presentScene:gameOverScene];
    }
}

@end
