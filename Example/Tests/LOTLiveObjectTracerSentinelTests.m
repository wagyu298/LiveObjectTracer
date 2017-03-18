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
    
    describe(@"addSentinelToObject", ^{

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
        
        it(@"Same sentinal for same delegate", ^{
            SentinelDelegate *delegate = [[SentinelDelegate alloc] init];
            NSObject *target = [[NSObject alloc] init];
            
            LOTLiveObjectTracerSentinel *s1 = [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate];
            LOTLiveObjectTracerSentinel *s2 = [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate];
            expect(s1).to.equal(s2);
        });
        
        it(@"Differ sentinal for differ delegate", ^{
            SentinelDelegate *delegate1 = [[SentinelDelegate alloc] init];
            SentinelDelegate *delegate2 = [[SentinelDelegate alloc] init];
            NSObject *target = [[NSObject alloc] init];
            
            LOTLiveObjectTracerSentinel *s1 = [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate1];
            LOTLiveObjectTracerSentinel *s2 = [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate2];
            expect(s1).notTo.equal(s2);
        });
        
        it(@"Differ sentinal for differ target", ^{
            SentinelDelegate *delegate = [[SentinelDelegate alloc] init];
            NSObject *target1 = [[NSObject alloc] init];
            NSObject *target2 = [[NSObject alloc] init];
            
            LOTLiveObjectTracerSentinel *s1 = [LOTLiveObjectTracerSentinel addSentinelToObject:target1 delegate:delegate];
            LOTLiveObjectTracerSentinel *s2 = [LOTLiveObjectTracerSentinel addSentinelToObject:target2 delegate:delegate];
            expect(s1).notTo.equal(s2);
        });
        
        it(@"Differ sentinal for differ target and delegate", ^{
            SentinelDelegate *delegate1 = [[SentinelDelegate alloc] init];
            SentinelDelegate *delegate2 = [[SentinelDelegate alloc] init];
            NSObject *target1 = [[NSObject alloc] init];
            NSObject *target2 = [[NSObject alloc] init];
            
            LOTLiveObjectTracerSentinel *s1 = [LOTLiveObjectTracerSentinel addSentinelToObject:target1 delegate:delegate1];
            LOTLiveObjectTracerSentinel *s2 = [LOTLiveObjectTracerSentinel addSentinelToObject:target2 delegate:delegate2];
            expect(s1).notTo.equal(s2);
        });
        
    });
    
    describe(@"removeSentinelToObject", ^{
        
        it(@"removeSentinelToObject", ^{
            SentinelDelegate *delegate = [[SentinelDelegate alloc] init];
            
            waitUntil(^(DoneCallback done) {
                NSObject *target = [[NSObject alloc] init];
                [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate];
                expect(delegate.delegateCalled).to.beFalsy();
                [LOTLiveObjectTracerSentinel removeSentinelFromObject:target delegate:delegate];
                expect(delegate.delegateCalled).to.beFalsy();
                done();
            });
            
            expect(delegate.delegateCalled).to.beFalsy();
        });
        
    });

});

SpecEnd
