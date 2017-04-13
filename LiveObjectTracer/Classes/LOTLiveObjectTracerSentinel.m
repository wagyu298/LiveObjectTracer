// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <objc/runtime.h>
#import "LOTLiveObjectTracerSentinel.h"

@implementation LOTLiveObjectTracerSentinel

- (instancetype)initWithObject:(id)object delegate:(id <LOTLiveObjectTracerSentinelDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        objc_setAssociatedObject(object, (__bridge void *)delegate, self, OBJC_ASSOCIATION_RETAIN);
    }
    return self;
}

- (void)dealloc
{
    if ([self.delegate respondsToSelector:@selector(lot_sentinelDidObjectReleased:)]) {
        [self.delegate lot_sentinelDidObjectReleased:self];
    }
}

- (void)detachFromObject:(id)object
{
    id <LOTLiveObjectTracerSentinelDelegate> delegate = self.delegate;
    [self willChangeValueForKey:@"delegate"];
    _delegate = nil;
    objc_setAssociatedObject(object, (__bridge void *)delegate, nil, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"delegate"];
}

+ (instancetype)addSentinelToObject:(id)object delegate:(id <LOTLiveObjectTracerSentinelDelegate>)delegate
{
    LOTLiveObjectTracerSentinel *sentinel = [self sentinelWithObject:object delegate:delegate];
    if (sentinel) {
        return sentinel;
    }
    return [[LOTLiveObjectTracerSentinel alloc] initWithObject:object delegate:delegate];
}

+ (void)removeSentinelFromObject:(id)object delegate:(id <LOTLiveObjectTracerSentinelDelegate>)delegate
{
    LOTLiveObjectTracerSentinel *sentinel = [self sentinelWithObject:object delegate:delegate];
    if (sentinel) {
        [sentinel detachFromObject:object];
    }
}

+ (instancetype)sentinelWithObject:(id)object delegate:(id <LOTLiveObjectTracerSentinelDelegate>)delegate

{
    return (LOTLiveObjectTracerSentinel *)objc_getAssociatedObject(object, (__bridge void *)delegate);
}

@end
