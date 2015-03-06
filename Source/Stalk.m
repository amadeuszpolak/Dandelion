
#import "Stalk.h"

@interface Stalk () {
    CCAnimation *movingAnim;
}

@end

@implementation Stalk

// 1
-(id)initWithSpriteFrameName:(NSString *)spriteFrameName
{
    if (self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName]]) {
        [self loadAnimations];
    }
    return self;
}

-(void)loadAnimations {
    movingAnim = [self loadAnimationFromPlist:@"movingAnim" forClass:@"Stalk"];
}

-(void)update:(CCTime)dt
{

}

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
            [self setSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Stalk1.png"]];
            break;
        default:
            [self setSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Stalk1.png"]];
            break;
    }
    if (action) {
        [self runAction:action];
    }
}


@end
