#define flowerWidth 8
#define flowerHeight 8

#import "ClassicScene.h"

#import "Flower.h"

@interface Flower () {
    CCAnimation *movingAnim;
}

@end

@implementation Flower

//init with frame from cache and load animations of single flower
-(id)initWithSpriteFrameName:(NSString *)spriteFrameName
{
    if (self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName]]) {
        [self loadAnimations];
    }
    return self;
}

-(void)loadAnimations {
    movingAnim = [self loadAnimationFromPlist:@"movingAnim" forClass:@"Flower"];
}

-(void)update:(CCTime)dt
{
    if (self.isActive) {
        
        if (self.initialForcesDefined==NO) {
            self.initialForcesDefined=YES;
            self.velocity = ccp(self.horizontalForce, self.verticalForce);
            self.velocity = ccp(self.horizontalForce, self.verticalForce);
        }
        
        if (self.position.y<=self.stopMovingPosition) {
            [self changeState:stateOnGround];
            self.gravityForce = 0;
            self.velocity = ccp(0,0);
            self.isActive=NO;
        }
        
        CGPoint gravity = ccp(0.0, -self.gravityForce);
        CGPoint gravityStep = ccpMult(gravity, dt);
    
        self.velocity = ccpAdd(self.velocity, gravityStep);
        self.desiredPosition = ccpAdd(self.position, ccpMult(self.velocity, dt));
        self.position = self.desiredPosition;
    }
}

//for future collisions - defining collision boxes, another approach would be using box2d/chipmunk to define shapes
-(CGRect)collisionBoundingBox {
    CGRect bounding = CGRectMake(self.desiredPosition.x - (flowerWidth / 2), self.desiredPosition.y - (flowerHeight / 2), flowerWidth, flowerHeight);
    return CGRectOffset(bounding, 0, 0);
}

//animation state machine
-(void)changeState:(CharacterStates)newState {
    if (newState == self.characterState) {
        return;
    }
    self.characterState = newState;
    [self stopAllActions];
    id action = nil;
    switch (newState) {
        case stateMoving:
            action = [CCActionAnimate actionWithAnimation:movingAnim];
            break;
        case stateStatic:
            [self setSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flower1.png"]];
            break;
        case stateOnGround:
            [self setSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flower2.png"]];
            break;
        default:
            [self setSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flower1.png"]];
            break;
    }
    if (action) {
        [self runAction:action];
    }
}

@end
