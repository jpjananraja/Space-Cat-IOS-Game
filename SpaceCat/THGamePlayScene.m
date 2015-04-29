//
//  THGamePlayScene.m
//  SpaceCat
//
//  Created by Janan Rajaratnam on 4/21/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

#import "THGamePlayScene.h"
#import "THMachineNode.h"
#import "THSpaceCatNode.h"
#import "THProjectileNode.h"
#import "THSpaceDogNode.h"
#import "THGroundNode.h"
#import "THUtil.h"
#import "THHudNode.h"
#import "THGameOverNode.h"
#import <AVFoundation/AVFoundation.h>



@interface THGamePlayScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;


@property (strong, nonatomic) SKAction *damageSFX;
@property (strong, nonatomic) SKAction *explodeSFX;
@property (strong, nonatomic) SKAction *laserSFX;

@property (nonatomic) BOOL gameOver;

@property (nonatomic) BOOL restart;

@property (nonatomic) BOOL gameOverDisplayed;

@property (strong, nonatomic) AVAudioPlayer *backGroundMusic;
@property (strong, nonatomic) AVAudioPlayer *gameOverMusic;

@end


@implementation THGamePlayScene


-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        
        //Changed the addEnemyTimeInterval to a zero and see the unexpected result
//        self.addEnemyTimeInterval = 0;
         self.addEnemyTimeInterval = 1.5;
        self.totalGameTime = 0;
        self.minSpeed = THSpaceDogMinSpeed;
        self.restart = NO;
        self.gameOver = NO;
        self.gameOverDisplayed = NO;
        
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        [self addChild:background];
        
        
        THMachineNode *machine = [THMachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 38)];
        
        [self addChild:machine];
        
        THSpaceCatNode *spaceCat = [THSpaceCatNode spaceCatAtPosition:CGPointMake(machine.position.x, machine.position.y - 2)];
                
        [self addChild:spaceCat];
        
        
        //Removed from init method and added to the update method to spawn multiple targets
//        [self addSpaceDog];
        
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8 );
       
        //The scene is the delegate for SkPhysicsContactDelegate
        self.physicsWorld.contactDelegate = self;
        
        
        THGroundNode *ground = [THGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 48)];
        [self addChild:ground];
        
        
        [self setupSounds];
        
        THHudNode *hud = [THHudNode hudAtPosition:CGPointMake(0, self.frame.size.height -20) inFrame:self.frame];
        
        [self addChild:hud];
        
    }
    
    return self;
}


-(void)setupSounds
{
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
     self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
     self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
    
    self.backGroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backGroundMusic.numberOfLoops = -1; //-1 repeats infinitely
    [self.backGroundMusic prepareToPlay];

    
    NSURL *gameOverURL = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@"mp3"];
    
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverURL error:nil];
    self.gameOverMusic.numberOfLoops = 1;
    [self.gameOverMusic prepareToPlay];
}



-(void)didMoveToView:(SKView *)view
{
    [self.backGroundMusic play];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!self.gameOver) {
        for (UITouch *touch in touches) {
            CGPoint position = [touch locationInNode:self];
            [self shootProjectileTowardsPosition:position];
        }
    }
    else if (self.restart)
    {
       //Destroys all the current nodes after game over
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        
        //Creates a new gameplay scene for new game
        THGamePlayScene *scene = [THGamePlayScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
        
        //If the scene zposition  is not set to -1, then all the other nodes appear behind it
        scene.zPosition = -1;
        
    }
    
    
}



-(void)performGameOver
{
    THGameOverNode *gameOver = [THGameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    
    [self addChild:gameOver];
    self.restart = YES;
    self.gameOverDisplayed = YES;
    
    [gameOver performAnimation];
    [self.backGroundMusic stop];
    [self.gameOverMusic play];
    
}



-(void)shootProjectileTowardsPosition:(CGPoint) position
{
    THSpaceCatNode *spaceCat = (THSpaceCatNode *)[self childNodeWithName:@"SpaceCat"];
    [spaceCat performTap];
    
    THMachineNode *machine = (THMachineNode *)[self childNodeWithName:@"Machine"];
    
    
    
    THProjectileNode *projectile = [THProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y + machine.frame.size.height - 15)];
    [self addChild:projectile];
    
    [projectile moveTowardsPosition:position];
    
    [self runAction:self.laserSFX];
    
    
}

-(void) addSpaceDog
{
//    THSpaceDogNode *spaceDogA = [THSpaceDogNode spaceDogOfType:THSpaceDogTypeA];
//    spaceDogA.position = CGPointMake(100, 300);
//    [self addChild:spaceDogA];
//    
//    THSpaceDogNode *spaceDogB = [THSpaceDogNode spaceDogOfType:THSpaceDogTypeB];
//    spaceDogB.position = CGPointMake(200, 300);
//    [self addChild:spaceDogB];
    
    //max is not inclusive therefore 2  instead of 1
    NSUInteger randomSpaceDog = [THUtil randomWithMin:0 max:2];
    
    THSpaceDogNode *spaceDog = [THSpaceDogNode spaceDogOfType:randomSpaceDog];
   
    //The two lines of code randomise the velocity at which they descend
    float dy = [THUtil randomWithMin:THSpaceDogMinSpeed max:THSpaceDogMaxSpeed];
    
    //taken from spacedognode.m
    spaceDog.physicsBody.velocity = CGVectorMake(0, dy); // -y value descends them +y ascends

    
    float y = self.frame.size.height + spaceDog.size.height;
    
    //Appears between the left edge and right edge of the screen
    float x = [THUtil randomWithMin:10 + spaceDog.size.width max:self.frame.size.width - 73];
    
    spaceDog.position = CGPointMake(x, y);
    [self addChild:spaceDog];
    
    
}



-(void)didBeginContact:(SKPhysicsContact *)contact
{
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    
    // 0000 < 0010
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA; // then this is the enemy
        secondBody = contact.bodyB; // this is the projectile
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    
    if (firstBody.categoryBitMask == THCollisionCategoryEnemy && secondBody.categoryBitMask == THCollisionCategoryProjectile)
    {
        NSLog(@"BOOOOOM");
        THSpaceDogNode *spaceDog = (THSpaceDogNode *)firstBody.node;
        THProjectileNode *projectile = (THProjectileNode *)secondBody.node;
        
        //Adding points code below will register points for every hit rather than every exploding hit
//        [self addPoints:THPointsPerHits];
        
        //Where the enemy meets contact with the projectile play the SFX and is damaged
      
        if ([spaceDog isDamaged]) {
            
            
            [self runAction:self.explodeSFX];
            
            [spaceDog removeFromParent];
            [projectile removeFromParent];
            [self createDebrisAtPosition:contact.contactPoint];
            
            [self addPoints:THPointsPerHits]; //Adds the points only when target explodes

        }
        
//        [self createDebrisAtPosition:contact.contactPoint];

    }
    else if (firstBody.categoryBitMask == THCollisionCategoryEnemy && secondBody.categoryBitMask == THCollisionCategoryGround)
    {
        NSLog(@"Hit the ground");
        
        THSpaceDogNode *spaceDog = (THSpaceDogNode *)firstBody.node;
        
        
        //Where the enemy meets contact with the ground play the SFX
        [self runAction:self.damageSFX];
        
        [spaceDog removeFromParent];
        [self createDebrisAtPosition:contact.contactPoint];
        
        [self loseLife];
       
    }
    
    //The following adds more debris  since it adds debris even on first contact
//    [self createDebrisAtPosition:contact.contactPoint];  //instead added to both -if and else
    
    
}


-(void)addPoints:(NSInteger)points
{
    
    THHudNode *hud = (THHudNode *)[self childNodeWithName:@"HUD"];
    [hud addPoints:points];
}


-(void) createDebrisAtPosition: (CGPoint)position
{
    NSInteger numberOfPieces = [THUtil randomWithMin:5 max:20];
    
    
    for(int i = 0; i < numberOfPieces; i++)
    {
        NSInteger randomPiece = [THUtil randomWithMin:1 max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%ld" , (long)randomPiece];
        
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        
        [self addChild:debris];
        
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = THCollisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.collisionBitMask = THCollisionCategoryGround | THCollisionCategoryDebris;
        debris.name = @"Debris";
        
        debris.physicsBody.velocity = CGVectorMake([THUtil randomWithMin:-150 max:150], [THUtil randomWithMin:150 max:350]);
        
        [debris runAction:[SKAction waitForDuration:2.0] completion:^{
            [debris removeFromParent];
        }];
    }
    
    //Create an emitter node
    
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
    
    
    SKEmitterNode *explosion =[NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    
    //Try commenting out the zPosition and the explosion will not appear
    explosion.zPosition = 1;
    
    
    explosion.position = position;
    [self addChild:explosion];
    
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
        [explosion removeFromParent];
    }];
    
}

-(void)update:(NSTimeInterval)currentTime
{
    
//    NSLog(@"%f", fmod(currentTime, 60));
    
//    [self addSpaceDog];
    
    
    if(self.lastUpdateTimeInterval)
    {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    if (self.timeSinceEnemyAdded > self.addEnemyTimeInterval && !self.gameOver) {
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
    
    
    //To change gameplay according to seconds played
    if(self.totalGameTime > 480)
    {
        //480 / 60 = 8 mins
        self.addEnemyTimeInterval = 0.50;
        self.minSpeed = -160;
    }
    else if(self.totalGameTime > 240)
    {
        //4 mins
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
    }
    else if(self.totalGameTime > 20)
    {
        //2 mins
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = 125;
    }
    else if(self.totalGameTime > 10)
    {
        self.addEnemyTimeInterval = 1;
        self.minSpeed = -100;
    }
    
    
    
    if(self.gameOver && !self.gameOverDisplayed)
    {
        [self performGameOver];
    }
    
    
    
    
    
    
}

-(void)loseLife
{
    THHudNode *hud = (THHudNode *) [self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
    
}




@end
