//
//  THProjectileNode.m
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/22/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import "THProjectileNode.h"
#import "THUtil.h"

@implementation THProjectileNode


+(id)projectileAtPosition:(CGPoint)position
{
    
    THProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
    projectile.position = position;
    projectile.name = @"Projectile";
    
    [projectile setupAnimation];
    
    [projectile setupPhysicsBody];
    
    
    return projectile;
}


-(void)setupAnimation
{
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"projectile_1"],
                          [SKTexture textureWithImageNamed:@"projectile_2"],
                          [SKTexture textureWithImageNamed:@"projectile_3"]
                          ];
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    SKAction *repeatAction = [SKAction repeatActionForever:animation];
    
    [self runAction:repeatAction];
    
}



-(void)moveTowardsPosition:(CGPoint)position
{
    
    //slope = (y3 - y1) / (x3 - x1)
    float slope = (position.y - self.position.y) / (position.x - self.position.x);
    
    // slope = (y2 - y1) / (x2 - x1)  // where x2 is -10
    // (y2 - y1) = slope (x2 - x1)
    // y2 = slope * x2 - slope * x1 + y1
    
    float offscreenX;
    
    if(position.x <= self.position.x)
    {
        offscreenX = -10;
    }
    else
    {
        offscreenX = self.parent.frame.size.width + 10;
    }
    
    
    float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
    
    CGPoint pointOffScreen = CGPointMake(offscreenX, offscreenY);
    
    float distanceA = pointOffScreen.y - self.position.y;
    float distanceB = pointOffScreen.x - self.position.x;
    
    //The pythagorean theorem
    float distanceC = sqrtf(powf(distanceA, 2) + pow(distanceB, 2));
    
    //distance = speed * time
    //time = distance / speed
    
    
    //Advanced fading mechanism instead of the one below
//    float height = self.parent.frame.size.height - self.position.y;
//    
//    float waitToFade;
//    if (pointOffScreen.x >= 0 || pointOffScreen.x <= self.parent.frame.size.width)
//    {
//        waitToFade = (height / THProjectileSpeed) * 0.75;
//    }
//    
//    float fadeTime = waitToFade;
    
    
    float time = distanceC / THProjectileSpeed;
    float waitToFade = time * 0.75;
    float fadeTime = time - waitToFade;
    
    SKAction *moveProjectile = [SKAction moveTo:pointOffScreen duration:time];
    
    [self runAction:moveProjectile];
    
    NSArray *sequence = @[[SKAction waitForDuration:waitToFade],
                          [SKAction fadeOutWithDuration:fadeTime],
                          [SKAction removeFromParent]];
    
    [self runAction:[SKAction sequence:sequence]];
}



-(void)setupPhysicsBody
{
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    
    self.physicsBody.categoryBitMask = THCollisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0;
    
    self.physicsBody.contactTestBitMask = THCollisionCategoryEnemy;
}


@end

