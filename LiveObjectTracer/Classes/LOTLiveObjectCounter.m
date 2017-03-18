// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import "LOTLiveObjectCounter.h"
#import "LOTLiveObjectTracerSentinel.h"

@interface LOTLiveObjectCounter () <LOTLiveObjectTracerSentinelDelegate>

@end

@implementation LOTLiveObjectCounter

- (instancetype)initWithDelegate:(id <LOTLiveObjectCounterDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)addObject:(id)object
{
    @synchronized (self) {
        if ([LOTLiveObjectTracerSentinel sentinelWithObject:object delegate:self]) {
            return;
        }
        
        NSUInteger prev = _count;
        [self willChangeValueForKey:@"count"];
        [LOTLiveObjectTracerSentinel addSentinelToObject:object delegate:self];
        _count++;
        [self didChangeValueForKey:@"count"];
        
        if ([self.delegate respondsToSelector:@selector(lot_counter:didChangeCount:previousCount:)]) {
            [self.delegate lot_counter:self didChangeCount:_count previousCount:prev];
        }
    }
}

- (void)lot_sentinelDidObjectReleased:(LOTLiveObjectTracerSentinel * _Nonnull)sentinel
{
    @synchronized (self) {
        NSUInteger prev = _count;
        [self willChangeValueForKey:@"count"];
        _count--;
        [self didChangeValueForKey:@"count"];
        
        if ([self.delegate respondsToSelector:@selector(lot_counter:didChangeCount:previousCount:)]) {
            [self.delegate lot_counter:self didChangeCount:_count previousCount:prev];
        }
    }
}

@end
