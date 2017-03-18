// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Foundation/Foundation.h>

@class LOTLiveObjectTracer;

@protocol LOTLiveObjectTracerDelegate <NSObject>

- (void)lot_tracerDidObjectReleased:(LOTLiveObjectTracer * _Nonnull)tracer;

@end

@interface LOTLiveObjectTracer : NSObject

@property (nonatomic, nullable, weak) id <LOTLiveObjectTracerDelegate> delegate;

@property (nonatomic, readonly) BOOL live;
@property (nonatomic, readonly) BOOL dead;

- (instancetype _Nonnull)initWithObject:(id _Nonnull)object delegate:(id <LOTLiveObjectTracerDelegate> _Nullable)delegate;
- (instancetype _Nonnull)initWithObject:(id _Nonnull)object;

- (BOOL)live;
- (BOOL)dead;

@end
