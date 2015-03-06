#import <Box2D/Box2D.h>

#import "MenuScene.h"

#import "PhysicsScene.h"

@implementation PhysicsScene {
    CCSprite *_sprite;
}

+ (PhysicsScene *)scene
{
    return [[self alloc] init];
}

- (id)init {
    // 2
    self = [super init];
    if (!self) return(nil);
    
    // 3
    self.userInteractionEnabled = YES;
    
    // 4
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    CCButton *backButton = [CCButton buttonWithTitle:@"Back" fontName:@"Verdana-Bold" fontSize:32.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.125f, 0.125f);
    [backButton setTarget:self selector:@selector(onBack:)];
    [self addChild:backButton];
    
    return self;
}

- (void)onBack:(id)sender
{
    //Transition
    [[CCDirector sharedDirector] replaceScene:[MenuScene scene]
                               withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

@end
