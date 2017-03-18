// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <LiveObjectTracer/LiveObjectTracer.h>

@interface SentinelDelegate: NSObject <LOTLiveObjectTracerSentinelDelegate>

@property (nonatomic) BOOL delegateCalled;

@end

@implementation SentinelDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegateCalled = NO;
    }
    return self;
}

- (void)lot_sentinelDidObjectReleased:(LOTLiveObjectTracerSentinel *)sentinel
{
    self.delegateCalled = YES;
}

@end

SpecBegin(LOTLiveObjectTracerSentinelTests)

describe(@"LOTLiveObjectTracerSentinelSpecs", ^{
    
    it(@"Trace object", ^{
        SentinelDelegate *delegate = [[SentinelDelegate alloc] init];
        
        waitUntil(^(DoneCallback done) {
            NSObject *target = [[NSObject alloc] init];
            LOTLiveObjectTracerSentinel *sentinel __attribute__((unused)) = [[LOTLiveObjectTracerSentinel alloc] initWithObject:target delegate:delegate];
            expect(delegate.delegateCalled).to.beFalsy();
            done();
        });
        
        expect(delegate.delegateCalled).to.beTruthy();
    });
    
});

SpecEnd
