//
//  THUtil.h
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/22/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int THProjectileSpeed = 300;
static const int THSpaceDogMinSpeed = -100;
static const int THSpaceDogMaxSpeed = -50;
static const int THMaxLives = 4;
static const int THPointsPerHits = 100;

typedef NS_OPTIONS(uint32_t, THCollisionCategory)
{
    THCollisionCategoryEnemy        = 1 << 0,   // 0000
    THCollisionCategoryProjectile   = 1 << 1,   // 0010
    THCollisionCategoryDebris       = 1 << 2,   // 0100
    THCollisionCategoryGround       = 1 << 3    // 1000
};

@interface THUtil : NSObject

+ (NSInteger) randomWithMin : (NSInteger)min max:(NSInteger)max;

@end
