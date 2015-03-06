#import "Stalk.h"

@interface ClassicScene : CCScene

@property (nonatomic, strong) NSMutableArray *_flowers;
@property (nonatomic, strong) Stalk *dandelionStalk;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, assign) double recorderResults;
@property (nonatomic, strong) NSTimer *levelTimer;
@property (nonatomic, assign) double micVolumeSample;

@property (nonatomic, strong) CCButton *restartButton;
@property (nonatomic, strong) CCLabelTTF *volumeLabel;

+ (ClassicScene *)scene;
- (id)init;

@end
