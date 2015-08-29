#import <Foundation/Foundation.h>

@class MirrorMulticastDelegateEnumerator;



@interface MirrorMulticastDelegate : NSObject


- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

- (void)removeAllDelegates;

- (NSUInteger)count;

- (MirrorMulticastDelegateEnumerator *)delegateEnumerator;

@end


