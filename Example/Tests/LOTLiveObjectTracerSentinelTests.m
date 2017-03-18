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
    
    it(@"addSentinelToObject", ^{
        SentinelDelegate *delegate = [[SentinelDelegate alloc] init];
        
        waitUntil(^(DoneCallback done) {
            NSObject *target = [[NSObject alloc] init];
            [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate];
            expect(delegate.delegateCalled).to.beFalsy();
            done();
        });
        
        expect(delegate.delegateCalled).to.beTruthy();
    });
    
    describe(@"sentinelWithObject", ^{
        
        it(@"Returns sentinel", ^{
            SentinelDelegate *delegate = [[SentinelDelegate alloc] init];
            NSObject *target = [[NSObject alloc] init];
            LOTLiveObjectTracerSentinel *s1 = [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate];
            LOTLiveObjectTracerSentinel *s2 = [LOTLiveObjectTracerSentinel sentinelWithObject:target];
            expect(s1).to.equal(s2);
        });
        
        it(@"Returns nil", ^{
            NSObject *target = [[NSObject alloc] init];
            LOTLiveObjectTracerSentinel *s = [LOTLiveObjectTracerSentinel sentinelWithObject:target];
            expect(s).to.equal(nil);
        });
    });
    
});

SpecEnd
