#import "ClassicScene.h"
#import "Flower.h"
#import "Stalk.h"

#define blowTreshold 15
#define nRows 3
#define nColumns 3

@implementation ClassicScene {
    
}

+ (ClassicScene *)scene
{
    return [[self alloc] init];
}

- (id)init {
    //Super init
    self = [super init];
    if (!self) return(nil);
    
    //Screen is touchable
    self.userInteractionEnabled = YES;
    
    //BG
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"bg.png"];
    bg.positionType = CCPositionTypeNormalized;
    bg.position = ccp(0.5f,0.5f);
    [self addChild:bg];
    
    //Mic volume label
    self.volumeLabel = [CCLabelTTF labelWithString:@"volume -160" fontName:@"Verdana-Bold" fontSize:32.0f];
    self.volumeLabel.positionType = CCPositionTypeNormalized;
    self.volumeLabel.position = ccp(0.750f,0.875f);
    [self addChild:self.volumeLabel];
    
    //Back button
    self.restartButton = [CCButton buttonWithTitle:@"Restart" fontName:@"Verdana-Bold" fontSize:32.0f];
    self.restartButton.positionType = CCPositionTypeNormalized;
    self.restartButton.position = ccp(0.750f, 0.0625f);
    [self.restartButton setTarget:self selector:@selector(onRestart:)];
    [self addChild:self.restartButton];
    
    //Stalk
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"StalkImages.plist"];
    self.dandelionStalk = [[Stalk alloc] initWithSpriteFrameName:@"Stalk1.png"];
    self.dandelionStalk.positionType = CCPositionTypePoints;
    self.dandelionStalk.position = ccp(self.contentSize.width/2,5*self.contentSize.height/12);
    [self addChild:self.dandelionStalk];
    
    //Init Flowers
    self._flowers = [[NSMutableArray alloc] init];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"FlowerImages.plist"];
    [self initFlowers];
    
    //Init mic
    self.micVolumeSample = -160;
    [self initMic];
    
    return self;
}

-(void)initMic {
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    AudioSessionSetActive(true);
    
    self.recorderResults=0;
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if (self.recorder) {
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
        [self.recorder record];
        self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        
    } else NSLog(@"recorder error");
}

- (void)levelTimerCallback:(NSTimer *)timer {
    
    [self.recorder updateMeters];
    double peakPowerForChannel = [self.recorder peakPowerForChannel:0];
    self.recorderResults = peakPowerForChannel;
    
    if (self.recorderResults > - blowTreshold) {
        self.recorder.meteringEnabled = NO;
        self.micVolumeSample = self.recorderResults;
        [self moveFlowers];
        self.recorderResults = -160;
    }
}

- (void)update:(CCTime)dt {
    
    for (Flower *target in self._flowers) {
        [target update:dt];
    }
}

-(void)initFlowers {
    for (int i=0; i<nRows; i++) {
        for (int j=0; j<nColumns; j++) {
                Flower *oneFlower = [[Flower alloc] initWithSpriteFrameName:@"Flower1.png"];
                oneFlower.positionType = CCPositionTypePoints;
                oneFlower.position = ccp(self.contentSize.width/2-8+8*j,(self.dandelionStalk.position.y+self.dandelionStalk.contentSize.height/2-oneFlower.contentSize.height/2)+8-8*i);
                [self addChild:oneFlower];
            
                oneFlower.treshold = arc4random()%(15);
                oneFlower.gravityForce=25;
                oneFlower.initialForcesDefined=NO;
                oneFlower.isActive=NO;
            
                int r=arc4random()%(2);
                if (r==0) {
                    oneFlower.flipX=YES;
                }
                else {
                    oneFlower.flipX=NO;
                }
            
                oneFlower.stopMovingPosition = self.contentSize.height/5;
            
                [self._flowers addObject:oneFlower];
            
        }
    }
}

- (void)onRestart:(id)sender
{
    //restart flowers position and initial values
    self.volumeLabel.string = [NSString stringWithFormat:@"volume    "];
    self.micVolumeSample = -160;
    int i = 0;
    int j = 0;
    for (Flower *target in self._flowers) {
        [target changeState:stateStatic];
        target.isActive = NO;
        target.initialForcesDefined = NO;
        target.gravityForce=25;
        target.velocity = ccp(0,0);
        target.position = ccp(self.contentSize.width/2-8+8*j,(self.dandelionStalk.position.y+self.dandelionStalk.contentSize.height/2-target.contentSize.height/2)+8-8*i);
        j++;
        if (j==nColumns) {
            i++;
            j=0;
        }
    }
    self.recorder.meteringEnabled = YES;
}

- (void)moveFlowers
{
    [self.dandelionStalk changeState:stateStatic];
    [self.dandelionStalk changeState:stateMoving];
    
    //activate flowers
    for (Flower *target in self._flowers) {
        if (abs((int)self.micVolumeSample)<=target.treshold) {
        target.isActive = YES;
        [target changeState:stateMoving];
        int x=-2+arc4random()%(4);
        int y=-2+arc4random()%(4);
        if (target.flipX==NO) {
            target.horizontalForce = -(blowTreshold/2 - (abs((int)self.micVolumeSample) + x)/2);
            target.verticalForce = 10*blowTreshold - 10*(abs((int)self.micVolumeSample) + y);
        }
        if (target.flipX==YES) {
            target.horizontalForce = blowTreshold/2 - (abs((int)self.micVolumeSample) + x)/2;
            target.verticalForce = 10*blowTreshold - 10*(abs((int)self.micVolumeSample) + y);
        }
    }
    }
    self.volumeLabel.string = [NSString stringWithFormat:@"volume %d", (int)self.micVolumeSample];
}

@end