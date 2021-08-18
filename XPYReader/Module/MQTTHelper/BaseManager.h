//
//  BaseManager.h
//  AlarmClock
//
//  Created by linpeng on 2020/3/18.
//  Copyright © 2020 RD8. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseManager : NSObject

@property (nonatomic, strong, readonly, class) BaseManager *sharedInstance;

+ (instancetype)sharedInstance;

+ (instancetype)sharedInstance:(BOOL)createIfNotExists;

+ (void)removeInstance;

// 观察者相关
- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

- (void)notifyObserversWithSelector:(SEL)selector;
- (void)notifyObserversWithSelector:(SEL)selector withObject:(id)object;
- (void)notifyObserversWithSelector:(SEL)selector withObjectOne:(id)objectOne objectTwo:(nullable id)objectTwo;
- (void)notifyObserversWithSelector:(SEL)selector withObjectOne:(id)objectOne objectTwo:(nullable id)objectTwo objectThree:(nullable id)objectThree;

// block 相关
- (void)addBlock:(id)block withKey:(NSString *)key;
- (NSMutableArray *)blocksWithKey:(NSString *)key;
- (void)clearBlocksForKey:(NSString *)key;
- (void)clearAllBlocks;

// 清理资源
- (void)invalidate;

#pragma mark - 错误相关

- (NSError *)makeErrorWithCode:(NSInteger)code message:(NSString *)message;

@end


NS_ASSUME_NONNULL_END
