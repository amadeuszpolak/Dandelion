#import "ClassicScene.h"
#import "PhysicsScene.h"

#import "MenuScene.h"

@implementation MenuScene {
    CCSprite *_sprite;
}

+ (MenuScene *)scene
{
    return [[self alloc] init];
}

- (id)init {
    //Super init
    self = [super init];
    if (!self) return(nil);
    
    //Screen is touchable
    self.userInteractionEnabled = YES;
    
    //BG color
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //Menu
    CCButton *classicButton = [CCButton buttonWithTitle:@"Classic" fontName:@"Verdana-Bold" fontSize:32.0f];
    classicButton.positionType = CCPositionTypeNormalized;
    classicButton.position = ccp(0.5f, 0.35f);
    [classicButton setTarget:self selector:@selector(onClassic:)];
    [self addChild:classicButton];
    
    CCButton *physicsButton = [CCButton buttonWithTitle:@"Physics" fontName:@"Verdana-Bold" fontSize:32.0f];
    physicsButton.positionType = CCPositionTypeNormalized;
    physicsButton.position = ccp(0.5f, 0.65f);
    [physicsButton setTarget:self selector:@selector(onPhysics:)];
    [self addChild:physicsButton];
    
    return self;
}

- (void)onClassic:(id)sender
{
    //Transition
    [[CCDirector sharedDirector] replaceScene:[ClassicScene scene]
                               withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

- (void)onPhysics:(id)sender
{
    //Transition
    [[CCDirector sharedDirector] replaceScene:[PhysicsScene scene]
                               withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

@end
