// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Foundation/Foundation.h>

@class LOTLiveObjectCounter;

@protocol LOTLiveObjectCounterDelegate <NSObject>

- (void)lot_counter:(LOTLiveObjectCounter * _Nonnull)counter didChangeCount:(NSUInteger)count previousCount:(NSUInteger)previousCount;

@end

@interface LOTLiveObjectCounter : NSObject

@property (nonatomic, nullable, weak) id <LOTLiveObjectCounterDelegate> delegate;
@property (nonatomic, readonly) NSUInteger count;

- (instancetype _Nonnull)initWithDelegate:(id <LOTLiveObjectCounterDelegate> _Nullable)delegate;

- (void)addObject:(id _Nonnull)object;

@end
