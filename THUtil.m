//
//  THUtil.m
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/22/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import "THUtil.h"

@implementation THUtil

+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max
{
    return arc4random() % (max - min) + min;
}


@end
