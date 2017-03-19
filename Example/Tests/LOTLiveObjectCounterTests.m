// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <OCMock/OCMock.h>
#import <LiveObjectTracer/LiveObjectTracer.h>

SpecBegin(LOTLiveObjectCounterTests)

describe(@"LOTLiveObjectCounterSpecs", ^{
    
    describe(@"addObject", ^{
        
        describe(@"w/o delegate", ^{
            
            it(@"Count objects", ^{
                LOTLiveObjectCounter *counter = [[LOTLiveObjectCounter alloc] init];
                expect(counter.count).to.equal(0);
                
                waitUntil(^(DoneCallback done) {
                    NSObject *target1 = [[NSObject alloc] init];
                    [counter addObject:target1];
                    expect(counter.count).to.equal(1);
                    
                    NSObject *target2 = [[NSObject alloc] init];
                    [counter addObject:target2];
                    expect(counter.count).to.equal(2);
                    
                    done();
                });
                
                expect(counter.count).to.equal(0);
            });
            
            it(@"Count duplicated objects", ^{
                LOTLiveObjectCounter *counter = [[LOTLiveObjectCounter alloc] init];
                expect(counter.count).to.equal(0);
                
                waitUntil(^(DoneCallback done) {
                    NSObject *target1 = [[NSObject alloc] init];
                    [counter addObject:target1];
                    expect(counter.count).to.equal(1);
                    
                    [counter addObject:target1];
                    expect(counter.count).to.equal(1);
                    
                    NSObject *target2 = [[NSObject alloc] init];
                    [counter addObject:target2];
                    expect(counter.count).to.equal(2);
                    
                    [counter addObject:target2];
                    expect(counter.count).to.equal(2);
                    
                    done();
                });
                
                expect(counter.count).to.equal(0);
            });
            
        });
        
        describe(@"w/ delegate", ^{
            
            it(@"Count objects", ^{
                id delegate = OCMProtocolMock(@protocol(LOTLiveObjectCounterDelegate));
                OCMStub([delegate lot_counter:[OCMArg any] didChangeCount:0 previousCount:0]).andDo(nil);
                LOTLiveObjectCounter *counter = [[LOTLiveObjectCounter alloc] initWithDelegate:delegate];
                expect(counter.count).to.equal(0);
                
                waitUntil(^(DoneCallback done) {
                    NSObject *target1 = [[NSObject alloc] init];
                    [counter addObject:target1];
                    expect(counter.count).to.equal(1);
                    OCMVerify([delegate lot_counter:OCMOCK_ANY didChangeCount:1 previousCount:0]);
                    
                    NSObject *target2 = [[NSObject alloc] init];
                    [counter addObject:target2];
                    expect(counter.count).to.equal(2);
                    OCMVerify([delegate lot_counter:OCMOCK_ANY didChangeCount:2 previousCount:1]);
                    
                    done();
                });
                
                expect(counter.count).to.equal(0);
                OCMVerify([delegate lot_counter:OCMOCK_ANY didChangeCount:0 previousCount:1]);
            });
            
        });
        
    });
    
    describe(@"removeObject", ^{
        
        it(@"Remove with delegate call", ^{
            id delegate = OCMProtocolMock(@protocol(LOTLiveObjectCounterDelegate));
            OCMStub([delegate lot_counter:[OCMArg any] didChangeCount:0 previousCount:0]).andDo(nil);
            LOTLiveObjectCounter *counter = [[LOTLiveObjectCounter alloc] initWithDelegate:delegate];
            expect(counter.count).to.equal(0);
            
            NSObject *target1 = [[NSObject alloc] init];
            [counter addObject:target1];
            expect(counter.count).to.equal(1);
            OCMVerify([delegate lot_counter:OCMOCK_ANY didChangeCount:1 previousCount:0]);
            
            [counter removeObject:target1];
            expect(counter.count).to.equal(0);
            OCMVerify([delegate lot_counter:OCMOCK_ANY didChangeCount:0 previousCount:1]);
        });
        
        it(@"Count objects", ^{
            id delegate = OCMProtocolMock(@protocol(LOTLiveObjectCounterDelegate));
            OCMStub([delegate lot_counter:[OCMArg any] didChangeCount:0 previousCount:0]).andDo(nil);
            LOTLiveObjectCounter *counter = [[LOTLiveObjectCounter alloc] initWithDelegate:delegate];
            expect(counter.count).to.equal(0);
            
            waitUntil(^(DoneCallback done) {
                NSObject *target1 = [[NSObject alloc] init];
                [counter addObject:target1];
                expect(counter.count).to.equal(1);
                OCMVerify([delegate lot_counter:OCMOCK_ANY didChangeCount:1 previousCount:0]);
                
                NSObject *target2 = [[NSObject alloc] init];
                [counter addObject:target2];
                expect(counter.count).to.equal(2);
                OCMVerify([delegate lot_counter:OCMOCK_ANY didChangeCount:2 previousCount:1]);
                
                [counter removeObject:target2];
                expect(counter.count).to.equal(1);
                OCMVerify([delegate lot_counter:OCMOCK_ANY didChangeCount:1 previousCount:2]);
                
                done();
            });
            
            expect(counter.count).to.equal(0);
            OCMVerify([delegate lot_counter:OCMOCK_ANY didChangeCount:0 previousCount:1]);
        });
        
    });
    
});

SpecEnd
