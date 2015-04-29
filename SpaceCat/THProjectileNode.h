//
//  THProjectileNode.h
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/22/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface THProjectileNode : SKSpriteNode

+(id)projectileAtPosition: (CGPoint)position;
-(void)moveTowardsPosition:(CGPoint)position;

@end
