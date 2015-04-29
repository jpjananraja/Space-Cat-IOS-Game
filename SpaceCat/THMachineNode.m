//
//  THMachineNode.m
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/22/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import "THMachineNode.h"

@implementation THMachineNode

+(id)machineAtPosition:(CGPoint)position
{
    THMachineNode *machine = [self spriteNodeWithImageNamed:@"machine_1"];
    machine.position = position;
    machine.anchorPoint = CGPointMake(0.5, 0);
    machine.name = @"Machine";
    machine.zPosition = 8; //placed right behind the space cat at 9 zposition
    
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"machine_1"] ,
                          [SKTexture textureWithImageNamed:@"machine_2"]];
    
    
    SKAction *machineAnimation = [SKAction animateWithTextures:textures timePerFrame:0.10];
    
    SKAction *machineRepeat = [SKAction repeatActionForever:machineAnimation];
    
    [machine runAction:machineRepeat];
    
    return machine;
}

@end
