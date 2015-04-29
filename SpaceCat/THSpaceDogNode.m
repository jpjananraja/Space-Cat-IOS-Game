//
//  THSpaceDogNode.m
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/23/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import "THSpaceDogNode.h"
#import "THUtil.h"

@implementation THSpaceDogNode

+(id)spaceDogOfType:(THSpaceDogType)type
{
    THSpaceDogNode *spaceDog;
    spaceDog.damaged = NO;
    
    
    NSArray *textures;
    
    if(type == THSpaceDogTypeA)
    {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_A_2"],
//                     [SKTexture textureWithImageNamed:@"spacedog_A_3"]
                     ];
        spaceDog.type = THSpaceDogTypeA;
    }
    else if (type == THSpaceDogTypeB)
    {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_3"],
//                     [SKTexture textureWithImageNamed:@"spacedog_B_4"]
                     ];
        
        spaceDog.type = THSpaceDogTypeB;
    }
    
    
    float scale = [THUtil randomWithMin:85 max:100] / 100.0f;
    spaceDog.xScale = scale;
    spaceDog.yScale = scale;
    
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    [spaceDog runAction:[SKAction repeatActionForever:animation] withKey:@"animation" ];
    
    [spaceDog setupPhysicsBody];
    
    
    return spaceDog;
}


-(void) setupPhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO; //YES MAKES THEM DROP RATHER THAN DESCEND
    
    //The below code has been shifted to gameplayscene.m and into addspacedog method
//    self.physicsBody.velocity = CGVectorMake(0, -50); // -y value descends them +y ascends
    
    self.physicsBody.categoryBitMask = THCollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0;
    
    // 0010 | 1000 = 1010
    self.physicsBody.contactTestBitMask = THCollisionCategoryProjectile |
                                            THCollisionCategoryGround;
    
    
}


-(BOOL)isDamaged
{
    NSArray *textures;
    
    //The first time the projectile meets contact with the dog
    if(!_damaged)
    {
        [self removeActionForKey:@"animation"];
        
        if(self.type == THSpaceDogTypeA)
        {
            textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_3"]];
            
        }
        else
        {
            textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_4"]];
            
        }
        
        SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
        [self runAction:[SKAction repeatActionForever:animation] withKey:@"damage_animation"];
        
        _damaged = YES;
        
        return NO; //Because the dog can't explode on the first contact. NO doesn't run "if ([spaceDog isDamaged]) {..." code block in "didBeginContact" method in THGamePlayScene.m
    }
//    else{
//        return YES;
//    }
    
    //can use the code line below instead of the else statement above
    
    return _damaged; //YES runs the "if ([spaceDog isDamaged]) {..." code block in "didBeginContact" method in THGamePlayScene.m
    
    
}

@end
