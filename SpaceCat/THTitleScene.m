//
//  THTitleScene.m
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/21/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import "THTitleScene.h"
#import "THGamePlayScene.h"
#import <AVFoundation/AVFoundation.h>

@interface THTitleScene ()

@property (strong, nonatomic) SKAction *pressStartSFX;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusic;


@end

@implementation THTitleScene

//Used instead of initWithSize method
//-(void)didMoveToView:(SKView *)view {
//    /* Setup your scene here */
//    
//
//    
//    
//   
//}


-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        [self addChild:background];
        
        self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@"mp3"];
        
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.backgroundMusic.numberOfLoops = -1; //-1 repeats infinitely
        [self.backgroundMusic prepareToPlay];
        
        
    }
    
    return self;
}



-(void)didMoveToView:(SKView *)view
{
    [self.backgroundMusic play];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self runAction:self.pressStartSFX];
    
    [self.backgroundMusic stop];
    
    THGamePlayScene *gamePlayScene = [THGamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:2.50];
    [self.view presentScene:gamePlayScene transition:transition];
    
}


@end
