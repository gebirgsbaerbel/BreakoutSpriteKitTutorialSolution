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
    }
    return self;
}

@end
