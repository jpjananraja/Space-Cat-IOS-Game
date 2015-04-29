//
//  THGameOverNode.h
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/29/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface THGameOverNode : SKNode

+(id) gameOverAtPosition: (CGPoint) position;
-(void) performAnimation;


@end
