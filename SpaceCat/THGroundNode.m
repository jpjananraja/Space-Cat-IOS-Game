//
//  THGroundNode.m
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/23/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import "THGroundNode.h"
#import "THUtil.h"

@implementation THGroundNode

+(id)groundWithSize:(CGSize)size
{
    
    THGroundNode *ground = [self spriteNodeWithColor:[SKColor clearColor] size:size];
    ground.name = @"Ground";
   ground.position = CGPointMake(size.width / 2, size.height/2);
    
    
    //change the zposition to 0 to have the green ground appear behind the background
    ground.zPosition = 1;
    
    [ground setupPhysicsBody];
    
    
    return ground;
}

-(void) setupPhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    
    
    //set the value to YES and see the results
    self.physicsBody.dynamic = NO;
    
    self.physicsBody.categoryBitMask = THCollisionCategoryGround;
    self.physicsBody.collisionBitMask = THCollisionCategoryDebris;
    self.physicsBody.contactTestBitMask = THCollisionCategoryEnemy;
    
}

@end
