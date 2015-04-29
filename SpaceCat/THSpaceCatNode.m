//
//  THSpaceCatNode.m
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/22/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import "THSpaceCatNode.h"

@interface THSpaceCatNode ()

@property (strong, nonatomic) SKAction *tapAction;

@end

@implementation THSpaceCatNode



-(SKAction *)tapAction
{
    if(_tapAction != nil) return _tapAction;
    
    //Try reversing the elements in the array spacecat_1 as the first then spacecat_2 for different results
    NSArray *catTextures = @[[SKTexture textureWithImageNamed:@"spacecat_2"] ,
                            [SKTexture textureWithImageNamed:@"spacecat_1"]
                             ];
    _tapAction = [SKAction animateWithTextures:catTextures timePerFrame:0.25];
    
    
    return _tapAction;
}

+(id)spaceCatAtPosition:(CGPoint)position
{
    THSpaceCatNode *spaceCat = [self spriteNodeWithImageNamed:@"spacecat_1"];
    spaceCat.position = position;
    spaceCat.anchorPoint = CGPointMake(0.5, 0);
    spaceCat.name = @"SpaceCat";
    spaceCat.zPosition = 9;

    
    return spaceCat;
}

//check code
-(void)performTap
{
    [self runAction:self.tapAction];
}


@end
