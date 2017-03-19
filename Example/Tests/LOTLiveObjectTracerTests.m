// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <OCMock/OCMock.h>
#import <LiveObjectTracer/LiveObjectTracer.h>

SpecBegin(LOTLiveObjectTracerTests)

describe(@"LOTLiveObjectTracerSpecs", ^{
    
    describe(@"w/o delegate", ^{
        
        it(@"Live or dead", ^{
            __block LOTLiveObjectTracer *tracer;
            
            waitUntil(^(DoneCallback done) {
                NSObject *target = [[NSObject alloc] init];
                tracer = [[LOTLiveObjectTracer alloc] initWithObject:target];
                expect(tracer.live).to.beTruthy();
                expect(tracer.dead).to.beFalsy();
                done();
            });
            
            expect(tracer.live).to.beFalsy();
            expect(tracer.dead).to.beTruthy();
            
            tracer = nil;
        });
        
    });
    
    describe(@"w/ delegate", ^{
        
        it(@"Live or dead", ^{
            id delegateMock = OCMProtocolMock(@protocol(LOTLiveObjectTracerDelegate));
            OCMStub([delegateMock lot_tracerDidObjectReleased:[OCMArg any]]).andDo(nil);
            __block LOTLiveObjectTracer *tracer;
            
            waitUntil(^(DoneCallback done) {
                NSObject *target = [[NSObject alloc] init];
                tracer = [[LOTLiveObjectTracer alloc] initWithObject:target delegate:delegateMock];
                expect(tracer.live).to.beTruthy();
                expect(tracer.dead).to.beFalsy();
                done();
            });
            
            expect(tracer.live).to.beFalsy();
            expect(tracer.dead).to.beTruthy();
            OCMVerify([delegateMock lot_tracerDidObjectReleased:OCMOCK_ANY]);
            
            tracer = nil;
        });
        
    });
    
});

SpecEnd
