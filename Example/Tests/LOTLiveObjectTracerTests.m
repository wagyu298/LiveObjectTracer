// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <LiveObjectTracer/LiveObjectTracer.h>

@interface TracerDelegate: NSObject <LOTLiveObjectTracerDelegate>

@property (nonatomic) BOOL delegateCalled;

@end

@implementation TracerDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegateCalled = NO;
    }
    return self;
}

- (void)lot_tracerDidObjectReleased:(LOTLiveObjectTracer *)tracer
{
    self.delegateCalled = YES;
}

@end

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
            TracerDelegate *delegate = [[TracerDelegate alloc] init];
            __block LOTLiveObjectTracer *tracer;
            
            waitUntil(^(DoneCallback done) {
                NSObject *target = [[NSObject alloc] init];
                tracer = [[LOTLiveObjectTracer alloc] initWithObject:target delegate:delegate];
                expect(tracer.live).to.beTruthy();
                expect(tracer.dead).to.beFalsy();
                done();
            });
            
            expect(tracer.live).to.beFalsy();
            expect(tracer.dead).to.beTruthy();
            expect(delegate.delegateCalled).to.beTruthy();
            
            tracer = nil;
        });
        
    });
    
});

SpecEnd
