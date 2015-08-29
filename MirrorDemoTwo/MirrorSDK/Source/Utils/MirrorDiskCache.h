#import <Foundation/Foundation.h>

#define CACHE_BAT_PREFIX            @"MIRROR_CACHE_BAT_PREFIX"
#define CACHE_COLOR_PREFIX          @"MIRROR_CACHE_COLOR_PREFIX"
#define CACHE_GLASS_BG_PREFIX       @"MIRROR_CACHE_GLASS_BG_PREFIX"
#define CACHE_MODEL_PREFIX          @"MIRROR_CACHE_MODEL_PREFIX"


@interface MirrorDiskCache : NSObject {
    NSString *_mirrorCachePath;
}

@property (nonatomic, readonly) NSString *mirrorCachePath;
@property (nonatomic) NSInteger limitOfSize; // bytes

+ (instancetype)sharedCache;

- (NSString *)filePathForKey:(NSString *)key;
- (BOOL)hasObjectForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

- (void)cacheObject:(NSData*)data forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

- (void)removeAllObjects; // will be called automatically when currentSize > limitOfSize.
- (void)removeObjectsByAccessedDate:(NSDate *)accessedDate;
- (void)removeObjectsUsingBlock:(BOOL (^)(NSString *filePath))block;



@end
