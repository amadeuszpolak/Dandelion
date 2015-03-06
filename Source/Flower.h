#import "GameObject.h"

@interface Flower : GameObject {

}

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;

@property (nonatomic, assign) float treshold;

@property (nonatomic, assign) int horizontalForce;
@property (nonatomic, assign) int verticalForce;
@property (nonatomic, assign) int gravityForce;

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL initialForcesDefined;

@property (nonatomic, assign) int stopMovingPosition;

-(CGRect)collisionBoundingBox;

@end
