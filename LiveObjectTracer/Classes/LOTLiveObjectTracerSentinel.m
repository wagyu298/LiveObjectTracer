// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <objc/runtime.h>
#import "LOTLiveObjectTracerSentinel.h"

static const char * const associatedKey = "LOTLiveObjectTracer";

/*!
 @brief Internal category
 */
@interface LOTLiveObjectTracerSentinel ()

/*!
 @brief Constructor with tracing target object and delegate object.
 @param object An object to trace living
 @param delegate A delegate object
 */
- (instancetype _Nonnull)initWithObject:(id _Nonnull)object delegate:(id <LOTLiveObjectTracerSentinelDelegate> _Nonnull)delegate;

@end

@implementation LOTLiveObjectTracerSentinel

- (instancetype)initWithObject:(id)object delegate:(id <LOTLiveObjectTracerSentinelDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        objc_setAssociatedObject(object, associatedKey, self, OBJC_ASSOCIATION_RETAIN);
    }
    return self;
}

- (void)dealloc
{
    if ([self.delegate respondsToSelector:@selector(lot_sentinelDidObjectReleased:)]) {
        [self.delegate lot_sentinelDidObjectReleased:self];
    }
}

+ (instancetype)addSentinelToObject:(id)object delegate:(id <LOTLiveObjectTracerSentinelDelegate>)delegate
{
    return [[LOTLiveObjectTracerSentinel alloc] initWithObject:object delegate:delegate];
}

+ (instancetype)sentinelWithObject:(id)object
{
    return (LOTLiveObjectTracerSentinel *)objc_getAssociatedObject(object, associatedKey);
}

@end
