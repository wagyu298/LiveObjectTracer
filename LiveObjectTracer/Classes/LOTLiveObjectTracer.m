// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import "LOTLiveObjectTracer.h"
#import "LOTLiveObjectTracerSentinel.h"

@interface LOTLiveObjectTracer () <LOTLiveObjectTracerSentinelDelegate>

@end

@implementation LOTLiveObjectTracer

@dynamic dead;

- (instancetype)initWithObject:(id)object delegate:(id <LOTLiveObjectTracerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _live = YES;
        [LOTLiveObjectTracerSentinel addSentinelToObject:object delegate:self];
    }
    return self;
}

- (instancetype)initWithObject:(id)object
{
    return [self initWithObject:object delegate:nil];
}

- (BOOL)dead
{
    return !self.live;
}

- (void)lot_sentinelDidObjectReleased:(LOTLiveObjectTracerSentinel * _Nonnull)sentinel
{
    [self willChangeValueForKey:@"live"];
    [self willChangeValueForKey:@"dead"];
    _live = NO;
    [self didChangeValueForKey:@"live"];
    [self didChangeValueForKey:@"dead"];
    
    if ([self.delegate respondsToSelector:@selector(lot_tracerDidObjectReleased:)]) {
        [self.delegate lot_tracerDidObjectReleased:self];
    }
}

@end
