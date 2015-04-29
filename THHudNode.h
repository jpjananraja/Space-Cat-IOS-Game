//
//  THHudNode.h
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/28/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface THHudNode : SKNode

@property (nonatomic) NSInteger lives; //not strong because nsinteger is not object
@property (nonatomic) NSInteger score;

+(id) hudAtPosition: (CGPoint)position inFrame:(CGRect)frame;

-(void) addPoints: (NSInteger)points;
-(BOOL) loseLife;


@end
