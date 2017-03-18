// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Foundation/Foundation.h>

@class LOTLiveObjectTracerSentinel;

/*!
 @protocol LOTLiveObjectTracerSentinelDelegate.
 @brief Delegate protocol for LOTLiveObjectTracerSentinel
 */
@protocol LOTLiveObjectTracerSentinelDelegate <NSObject>

/*!
 @brief Called when LOTLiveObjectTracerSentinel target object was deallocated.
 @param sentinel Delegate method caller
 */
- (void)lot_sentinelDidObjectReleased:(LOTLiveObjectTracerSentinel * _Nonnull)sentinel;

@end

/*!
 @class LOTLiveObjectTracerSentinel
 @brief Sentinel for tracing the traget object's dealloc call.
 
 This class is core module of LiveObjectTracer.
 Don't keep the strong reference of this class. Because this class designed to dealloc with
 the target object's dealloc was called.
 */
@interface LOTLiveObjectTracerSentinel : NSObject

/// @brief A delegate object
@property (nonatomic, nullable, weak) id <LOTLiveObjectTracerSentinelDelegate> delegate;

/*!
 @brief Add the sentinel to the object.
 @param object An object to trace living
 @param delegate A delegate object
 */
+ (instancetype _Nonnull)addSentinelToObject:(id _Nonnull)object delegate:(id <LOTLiveObjectTracerSentinelDelegate> _Nonnull)delegate;

/*!
 @brief Returns the sentinel of the object if exist.
 @param object An object to trace living
 */
+ (instancetype _Nullable)sentinelWithObject:(id _Nonnull)object;

@end
