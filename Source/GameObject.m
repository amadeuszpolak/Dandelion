
#import "GameObject.h"

@implementation GameObject


-(id)initWithSpriteFrameName:(NSString *)spriteFrameName
{
    if (self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName]]) {
        [self loadAnimations];
        
    }
    return self;
}

-(void)loadAnimations {

}

-(void)update:(CCTime)dt
{

}

-(void)changeState:(CharacterStates)newState {
    
}

-(CCAnimation*)loadAnimationFromPlist:(NSString *)animationName forClass:(NSString *)className {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:className ofType:@"plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSDictionary *animationSettings = [plistDictionary objectForKey:animationName];
    
    CCAnimation *animation = [CCAnimation animation];
    
    animation.delayPerUnit = [[animationSettings objectForKey:@"delay"] floatValue];
    
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers) {
        NSString *frameName = [NSString stringWithFormat:@"%@%@.png",className,frameNumber];
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    return animation;
}

@end
