//
//  THHudNode.m
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/28/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import "THHudNode.h"
#import "THUtil.h"

@implementation THHudNode

+(id)hudAtPosition:(CGPoint)position inFrame:(CGRect)frame
{
    THHudNode *hud = [self node]; //creates a newly initialised node
    hud.position = position;
    hud.zPosition = 10;
    hud.name = @"HUD";
    
    SKSpriteNode *catHead = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_cat_1"];
    catHead.position = CGPointMake(70, -25);
    [hud addChild:catHead];
    
    
    hud.lives = THMaxLives;
    
    SKSpriteNode *lastLifeBar;
    
    for (int i =0; i < hud.lives;  i++)
    {
        SKSpriteNode *lifeBar = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_life_1"];
        lifeBar.name = [NSString stringWithFormat:@"Life %ld", (long)i+1];
        
        [hud addChild:lifeBar];
        
        if(lastLifeBar == nil)
        {
            lifeBar.position = CGPointMake(catHead.position.x + 30, catHead.position.y);
        }
        else
        {
            lifeBar.position = CGPointMake(lastLifeBar.position.x +10, lastLifeBar.position.y);
        }
        
        lastLifeBar = lifeBar; //commenting this only makes one bar appear
    }
    
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    
    scoreLabel.name = @"Score";
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 24;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.position = CGPointMake(frame.size.width-50, -28);
    
    [hud addChild:scoreLabel];
    
    
    
    return hud;
    
    
    
}


-(void) addPoints: (NSInteger)points
{
    self.score += points;
    
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:@"Score"];
    scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    
    
}


-(BOOL)loseLife
{
    if(self.lives > 0)
    {
        NSString *lifeNodeName = [NSString stringWithFormat:@"Life %ld", (long)self.lives];
        
        SKNode *lifeToRemove = [self childNodeWithName:lifeNodeName];
        [lifeToRemove removeFromParent];
        self.lives-- ;
        
    }
    
    return self.lives == 0;
    
    
    
    
}



@end
