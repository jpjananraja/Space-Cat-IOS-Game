//
//  THSpaceDogNode.h
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/23/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

//Is an NSUInteger enum type
typedef NS_ENUM(NSUInteger, THSpaceDogType) {
    THSpaceDogTypeA = 0,
    THSpaceDogTypeB = 1
};


@interface THSpaceDogNode : SKSpriteNode


@property (nonatomic, getter = isDamaged) BOOL damaged;
@property (nonatomic) THSpaceDogType type;

+(id)spaceDogOfType: (THSpaceDogType)type;
//-(BOOL)isDamaged;

@end
