// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <LiveObjectTracer/LiveObjectTracer.h>

@interface CounterDelegate: NSObject <LOTLiveObjectCounterDelegate>

@property (nonatomic) NSUInteger count;
@property (nonatomic) NSUInteger previousCount;

@end

@implementation CounterDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.count = 0;
        self.previousCount = 0;
    }
    return self;
}

- (void)lot_counter:(LOTLiveObjectCounter *)counter didChangeCount:(NSUInteger)count previousCount:(NSUInteger)previousCount
{
    self.count = count;
    self.previousCount = previousCount;
}

@end

SpecBegin(LOTLiveObjectCounterTests)

describe(@"LOTLiveObjectCounterSpecs", ^{
    
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
        
    });
    
    describe(@"w/ delegate", ^{
        
        it(@"Count objects", ^{
            CounterDelegate *delegate = [[CounterDelegate alloc] init];
            LOTLiveObjectCounter *counter = [[LOTLiveObjectCounter alloc] initWithDelegate:delegate];
            expect(counter.count).to.equal(0);
            
            waitUntil(^(DoneCallback done) {
                NSObject *target1 = [[NSObject alloc] init];
                [counter addObject:target1];
                expect(counter.count).to.equal(1);
                expect(delegate.count).to.equal(counter.count);
                expect(delegate.previousCount).to.equal(0);
                
                NSObject *target2 = [[NSObject alloc] init];
                [counter addObject:target2];
                expect(counter.count).to.equal(2);
                
                expect(delegate.count).to.equal(counter.count);
                expect(delegate.previousCount).to.equal(1);
                
                done();
            });
            
            expect(counter.count).to.equal(0);
            expect(delegate.count).to.equal(0);
            expect(delegate.previousCount).to.equal(1);
        });
        
    });
    
});

SpecEnd