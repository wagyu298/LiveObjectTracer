// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Foundation/Foundation.h>

@class LOTLiveObjectTracerSentinel;

@protocol LOTLiveObjectTracerSentinelDelegate <NSObject>

- (void)lot_sentinelDidObjectReleased:(LOTLiveObjectTracerSentinel * _Nonnull)sentinel;

@end

@interface LOTLiveObjectTracerSentinel : NSObject

@property (nonatomic, nullable, weak) id <LOTLiveObjectTracerSentinelDelegate> delegate;

- (instancetype _Nonnull)initWithObject:(id _Nonnull)object delegate:(id <LOTLiveObjectTracerSentinelDelegate> _Nonnull)delegate;

+ (instancetype _Nonnull)addSentinelToObject:(id _Nonnull)object delegate:(id <LOTLiveObjectTracerSentinelDelegate> _Nonnull)delegate;

@end
