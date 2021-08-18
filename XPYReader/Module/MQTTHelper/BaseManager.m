//
//  BaseManager.m
//  AlarmClock
//
//  Created by linpeng on 2020/3/18.
//  Copyright © 2020 RD8. All rights reserved.
//

#import "BaseManager.h"
#import <objc/message.h>

@interface BaseManager ()

@property (nonatomic, strong) NSHashTable *observers;
@property (nonatomic, strong) NSMutableDictionary *blocksDict;

@end

@implementation BaseManager

+ (instancetype)sharedInstance {
    return [self sharedInstance:YES];
}

static NSMutableDictionary *instances;
+ (instancetype)sharedInstance:(BOOL)createIfNotExists {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instances = [NSMutableDictionary dictionary];
    });
    
    NSString *key = NSStringFromClass([self class]);
    id object = instances[key];
    if (object == nil && createIfNotExists) {
        object = [self new];
        [instances setObject:object forKey:key];
    }
    return object;
}

+ (void)removeInstance {
    NSString *key = NSStringFromClass([self class]);
    BaseManager *manager = instances[key];
    [manager invalidate];
    [instances removeObjectForKey:key];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSHashTable *)observers {
    if (_observers == nil) {
        _observers = [NSHashTable weakObjectsHashTable];
    }
    
    return _observers;
}

- (NSMutableDictionary *)blocksDict {
    if (_blocksDict == nil) {
        _blocksDict = [NSMutableDictionary dictionary];
    }
    
    return _blocksDict;
}

- (void)addObserver:(id)observer {
    [self.observers addObject:observer];
}

- (void)notifyObserversWithSelector:(SEL)selector {
     [self notifyObserversWithSelector:selector withObjectOne:nil objectTwo:nil];
}

- (void)notifyObserversWithSelector:(SEL)selector withObject:(id)object {
    [self notifyObserversWithSelector:selector withObjectOne:object objectTwo:nil];
}

- (void)notifyObserversWithSelector:(SEL)selector withObjectOne:(id)objectOne objectTwo:(nullable id)objectTwo {
    [self notifyObserversWithSelector:selector withObjectOne:objectOne objectTwo:objectTwo objectThree:nil];
}

- (void)notifyObserversWithSelector:(SEL)selector withObjectOne:(id)objectOne objectTwo:(nullable id)objectTwo objectThree:(nullable id)objectThree {
    if (self.observers.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id observer in [self.observers copy]) {
                if([observer respondsToSelector:selector]) {
                    void (*callFuntion)(id, SEL, id, id, id) = (void(*)(id, SEL, id, id, id))objc_msgSend;
                    callFuntion(observer, selector, objectOne, objectTwo, objectThree);
                }
            }
        });
    }
}

- (void)removeObserver:(id)observer {
    [self.observers removeObject:observer];
}

- (void)addBlock:(id)block withKey:(NSString *)key {
    if (block == nil) {
        return;
    }
    NSMutableArray *blocksInKey = self.blocksDict[key];
    if (blocksInKey == nil) {
        blocksInKey = [NSMutableArray arrayWithCapacity:3];
        [self.blocksDict setObject:blocksInKey forKey:key];
    }
    [blocksInKey addObject:block];
}

- (NSMutableArray *)blocksWithKey:(NSString *)key {
    return self.blocksDict[key];
}

- (void)clearBlocksForKey:(NSString *)key {
    [self.blocksDict[key] removeAllObjects];
}

- (void)clearAllBlocks {
    [self.blocksDict removeAllObjects];
}

- (void)invalidate {
    // ...
    [self clearAllBlocks];
}

- (NSError *)makeErrorWithCode:(NSInteger)code message:(NSString *)message {
    static NSString *bundleName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];

    });
    return [NSError errorWithDomain:bundleName
                               code:code
                           userInfo:@{
                                      NSLocalizedDescriptionKey : message == nil ? @"" : message
                                      }];
}

@end
