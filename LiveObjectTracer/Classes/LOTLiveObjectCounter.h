// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Foundation/Foundation.h>

@class LOTLiveObjectCounter;

/*!
 @protocol LOTLiveObjectCounterDelegate.
 @brief Delegate protocol for LOTLiveObjectCounter
 */
@protocol LOTLiveObjectCounterDelegate <NSObject>

/*!
 @brief Called when LOTLiveObjectCounter's count property was changed.
 @param counter Delegate method caller
 @param count Live object count
 @param previousCount Previous live object count
 */
- (void)lot_counter:(LOTLiveObjectCounter * _Nonnull)counter didChangeCount:(NSUInteger)count previousCount:(NSUInteger)previousCount;

@end

/*!
 @class LOTLiveObjectCounter
 @brief Manage number of live objects.
 */
@interface LOTLiveObjectCounter : NSObject

/// @brief A delegate object.
@property (nonatomic, nullable, weak) id <LOTLiveObjectCounterDelegate> delegate;

/// @brief Number of live objects.
@property (nonatomic, readonly) NSUInteger count;

/*!
 @brief Constructor with delegate object.
 @param delegate A delegate object
 @return Instance itself
 */
- (instancetype _Nonnull)initWithDelegate:(id <LOTLiveObjectCounterDelegate> _Nullable)delegate;

/*!
 @brief Add an object to count live objects.
 @param object An object to manage
 */
- (void)addObject:(id _Nonnull)object;

/*!
 @brief Remove an object from count live objects.
 @param object An object to manage
 */
- (void)removeObject:(id _Nonnull)object;

@end
