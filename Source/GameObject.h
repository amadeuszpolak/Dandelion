typedef enum {
    stateStatic,
    stateOnGround,
    stateMoving
} CharacterStates;

@interface GameObject : CCSprite

@property (nonatomic, assign) CharacterStates characterState;

-(CCAnimation*)loadAnimationFromPlist:(NSString *)animationName forClass:(NSString *)className;
-(id)initWithSpriteFrameName:(NSString *)spriteFrameName;
-(void)loadAnimations;
-(void)changeState:(CharacterStates)newState;
-(void)update:(CCTime)dt;

@end
