#import <Box2D/Box2D.h>

#import "MyOwnPhysicsScene.h"

@implementation MyOwnPhysicsScene {
    CCSprite *_sprite;
}

+ (MyOwnPhysicsScene *)scene
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
    
    // 5
    _sprite = [CCSprite spriteWithImageNamed:@"iPhone.png"];
    _sprite.positionType = CCPositionTypeNormalized;
    _sprite.position  = ccp(0.5f,0.5f);
    [self addChild:_sprite];
    NSLog(@"%f",_sprite.position.x);
    
    // 6
    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    [_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    return self;
}

@end
