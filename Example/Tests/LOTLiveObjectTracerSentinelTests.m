// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <OCMock/OCMock.h>
#import <LiveObjectTracer/LiveObjectTracer.h>

SpecBegin(LOTLiveObjectTracerSentinelTests)

describe(@"LOTLiveObjectTracerSentinelSpecs", ^{
    
    describe(@"w/ mock", ^{
        __block id delegate;
        __block int nDelegateCalled;
        
        beforeEach(^{
            delegate = OCMProtocolMock(@protocol(LOTLiveObjectTracerSentinelDelegate));
            OCMStub([delegate lot_sentinelDidObjectReleased:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                // NOTE retainArguments required because lot_sentinelDidObjectReleased called from
                // dealloc method.
                [invocation retainArguments];
                nDelegateCalled++;
            });
            nDelegateCalled = 0;
        });
        
        afterEach(^{
            delegate = nil;
        });
        
        it(@"addSentinelToObject", ^{
            waitUntil(^(DoneCallback done) {
                NSObject *target = [[NSObject alloc] init];
                [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate];
                expect(nDelegateCalled).to.equal(0);
                done();
            });
            expect(nDelegateCalled).to.equal(1);
        });
        
        it(@"removeSentinelToObject", ^{
            waitUntil(^(DoneCallback done) {
                NSObject *target = [[NSObject alloc] init];
                [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate];
                expect(nDelegateCalled).to.equal(0);
                [LOTLiveObjectTracerSentinel removeSentinelFromObject:target delegate:delegate];
                expect(nDelegateCalled).to.equal(0);
                done();
            });
            
            expect(nDelegateCalled).to.equal(0);
        });
    
    });

    describe(@"addSentinelToObject", ^{
        __block id delegate1, delegate2;
        
        beforeEach(^{
            delegate1 = OCMProtocolMock(@protocol(LOTLiveObjectTracerSentinelDelegate));
            OCMStub([delegate1 lot_sentinelDidObjectReleased:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                [invocation retainArguments];
            });
            delegate2 = OCMProtocolMock(@protocol(LOTLiveObjectTracerSentinelDelegate));
            OCMStub([delegate2 lot_sentinelDidObjectReleased:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                [invocation retainArguments];
            });
        });
        
        afterEach(^{
            delegate1 = nil;
            delegate2 = nil;
        });

        it(@"Same sentinal for same delegate", ^{
            NSObject *target = [[NSObject alloc] init];
            
            LOTLiveObjectTracerSentinel *s1 = [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate1];
            LOTLiveObjectTracerSentinel *s2 = [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate1];
            expect(s1).to.equal(s2);
        });
        
        it(@"Differ sentinal for differ delegate", ^{
            NSObject *target = [[NSObject alloc] init];
            
            LOTLiveObjectTracerSentinel *s1 = [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate1];
            LOTLiveObjectTracerSentinel *s2 = [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate2];
            expect(s1).notTo.equal(s2);
        });
        
        it(@"Differ sentinal for differ target", ^{
            NSObject *target1 = [[NSObject alloc] init];
            NSObject *target2 = [[NSObject alloc] init];
            
            LOTLiveObjectTracerSentinel *s1 = [LOTLiveObjectTracerSentinel addSentinelToObject:target1 delegate:delegate1];
            LOTLiveObjectTracerSentinel *s2 = [LOTLiveObjectTracerSentinel addSentinelToObject:target2 delegate:delegate1];
            expect(s1).notTo.equal(s2);
        });
        
        it(@"Differ sentinal for differ target and delegate", ^{
            NSObject *target1 = [[NSObject alloc] init];
            NSObject *target2 = [[NSObject alloc] init];
            
            LOTLiveObjectTracerSentinel *s1 = [LOTLiveObjectTracerSentinel addSentinelToObject:target1 delegate:delegate1];
            LOTLiveObjectTracerSentinel *s2 = [LOTLiveObjectTracerSentinel addSentinelToObject:target2 delegate:delegate2];
            expect(s1).notTo.equal(s2);
        });
        
    });
    
    describe(@"LOLLiveObjectTracerSentinelInvalidArgumentException", ^{
        
        it(@"Throw w/ same object", ^{
            id delegate = OCMProtocolMock(@protocol(LOTLiveObjectTracerSentinelDelegate));
            expect(^{
                [LOTLiveObjectTracerSentinel addSentinelToObject:delegate delegate:delegate];
            }).to.raise(@"LOLLiveObjectTracerSentinelInvalidArgumentException");
        });
        
        it(@"Not throw w/o same object", ^{
            id delegate = OCMProtocolMock(@protocol(LOTLiveObjectTracerSentinelDelegate));
            OCMStub([delegate lot_sentinelDidObjectReleased:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                [invocation retainArguments];
            });
            NSObject *target = [[NSObject alloc] init];
            expect(^{
                [LOTLiveObjectTracerSentinel addSentinelToObject:target delegate:delegate];
            }).notTo.raiseAny();
        });
        
    });
    
});

SpecEnd
