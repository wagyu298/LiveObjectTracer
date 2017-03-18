// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Foundation/Foundation.h>

@class LOTLiveObjectTracer;

/*!
 @protocol LOTLiveObjectTracerDelegate.
 @brief Delegate protocol for LOTLiveObjectTracer
 */
@protocol LOTLiveObjectTracerDelegate <NSObject>

/*!
 @brief Called when LOTLiveObjectTracer tracing object was deallocated.
 @param tracer Delegate method caller
 */
- (void)lot_tracerDidObjectReleased:(LOTLiveObjectTracer * _Nonnull)tracer;

@end

/*!
 @class LOTLiveObjectTracer
 @brief Trace the target object was live or dead.
 */
@interface LOTLiveObjectTracer : NSObject

/// @brief A delegate object.
@property (nonatomic, nullable, weak) id <LOTLiveObjectTracerDelegate> delegate;

/// @brief YES if the object is live.
@property (nonatomic, readonly) BOOL live;

/// @brief YES if the object is dead (deallocated).
@property (nonatomic, readonly) BOOL dead;

/*!
 @brief Constructor with tracing target object and delegate object.
 @param object An object to trace living
 @param delegate A delegate object
 */
- (instancetype _Nonnull)initWithObject:(id _Nonnull)object delegate:(id <LOTLiveObjectTracerDelegate> _Nullable)delegate;

/*!
 @brief Constructor with tracing target object.
 @param object An object to trace living
 */
- (instancetype _Nonnull)initWithObject:(id _Nonnull)object;

@end
