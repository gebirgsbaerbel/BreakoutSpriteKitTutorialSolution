//
//  GameOverScene.m
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Köhler on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import "GameOverScene.h"
#import "BreakoutGameScene.h"

@implementation GameOverScene

- (id)initWithSize:(CGSize)size playerWon:(BOOL)isWon
{
    self = [super initWithSize:size];
    if (self) {
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        // 1
        SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        gameOverLabel.fontSize = 42;
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        if (isWon) {
            gameOverLabel.text = @"Game Won";
        } else {
            gameOverLabel.text = @"Game Over";
        }
        [self addChild:gameOverLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    BreakoutGameScene* breakoutGameScene = [[BreakoutGameScene alloc] initWithSize:self.size];
    // 2
    [self.view presentScene:breakoutGameScene];
}

@end
