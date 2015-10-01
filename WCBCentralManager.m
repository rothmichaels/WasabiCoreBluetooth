//
//  WCBCentralManager.m
//  WasabiCoreBluetooth
//
//  Created by Roth Michaels on 5/27/15.
//  Copyright (c) 2015 Roth Michaels.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may
//  not use this file except in compliance with the License.  You may obtain
//  a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "WCBCentralManager_Private.h"

#import "WCBCentralNotifications.h"
#import "WCBCentralNotificationCenter.h"

#define NSNC [NSNotificationCenter defaultCenter]

typedef void (^NotificationBlock)(NSNotification *);

@interface WCBCentralManager () {
@private
    NotificationBlock (^_wrapBlock)(NotificationBlock block);
    CBCentralManager *_centralManager;
    NSMutableSet *_observers;
}

- (void)unregisterDelegate;

@end

@implementation WCBCentralManager

+ (CBCentralManager *)sharedCentral
{
    static CBCentralManager *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id<CBCentralManagerDelegate> delegate = [[WCBCentralNotificationCenter alloc] init];
        dispatch_queue_t queue = dispatch_queue_create("wcb.centralmanager.queue", DISPATCH_QUEUE_SERIAL);
        NSDictionary *options = nil;
        singleton = [[CBCentralManager alloc] initWithDelegate:delegate queue:queue options:options];
    });
    return singleton;
}

- (instancetype)initWithConcurrencyType:(WCBCentralManagerConcurrencyType)type
{
    if ((self = [super init])) {
        switch (type) {
            case WCBBluetoothQueueConcurrencyType:
                _wrapBlock = ^(NotificationBlock block) {
                    return block;
                };
                break;
            case WCBBackgroundConcurrencyType: {
                dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
                _wrapBlock = ^(NotificationBlock block) {
                    return ^(NSNotification *notification) {
                        dispatch_async(queue, ^{
                            block(notification);
                        });
                    };
                };
                break;
            }
            case WCBMainQueueConcurrencyType: {
                dispatch_queue_t queue = dispatch_get_main_queue();
                _wrapBlock = ^(NotificationBlock block) {
                    return ^(NSNotification *notification) {
                        dispatch_sync(queue, ^{
                            block(notification);
                        });
                    };
                };
                break;
            }
            default:
                return nil;
        }
        _observers = [[NSMutableSet alloc] initWithCapacity:8];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithConcurrencyType:WCBBluetoothQueueConcurrencyType];
}

- (void)dealloc
{
    [self unregisterDelegate];
}

- (void)registerDelegateNotification:(NSString *)name
                ifRespondsToSelector:(SEL)selector
                              object:(id)object
                               block:(NotificationBlock)block

{
    if ([_delegate respondsToSelector:selector]) {
        id<NSObject> observer = [NSNC addObserverForName:name
                                                  object:object
                                                   queue:nil
                                              usingBlock:_wrapBlock(block)];
        if (observer != nil) {
            [_observers addObject:observer];
        }
    }
}

- (void)setDelegate:(id<WCBCentralManagerDelegate>)newDelegate
{
    [self unregisterDelegate];
    
    _delegate = newDelegate;
    if (newDelegate != nil) {
        WCBCentralManager *central = self;
        id nc = [WCBCentralManager sharedCentral].delegate;
        NSAssert([nc isKindOfClass:[WCBCentralNotificationCenter class]], @"Unexpected CBCentralManagerDelegate class.");
        [self registerDelegateNotification:WCBCNDidUpdateState
                      ifRespondsToSelector:@selector(centralManagerDidUpdateState:)
                                    object:nc
                                     block:^(NSNotification *notification) {
                                         [newDelegate centralManagerDidUpdateState:central];
                                     }];
        [self registerDelegateNotification:WCBCNWillRestoreState
                      ifRespondsToSelector:@selector(centralManager:willRestoreState:)
                                    object:nc
                                     block:^(NSNotification *notification) {
                                         [newDelegate centralManager:central
                                                    willRestoreState:notification.userInfo];
                                     }];
        [self registerDelegateNotification:WCBCNDidRetrievePeripherals
                      ifRespondsToSelector:@selector(centralManager:didRetrievePeripherals:)
                                    object:nc
                                     block:^(NSNotification *notification) {
                                         NSArray *peripherals = notification.userInfo[WCBCNUserInfoPeripheralArray];
                                         [newDelegate centralManager:central
                                              didRetrievePeripherals:peripherals];
                                     }];
        [self registerDelegateNotification:WCBCNDidRetrieveConnectedPeripherals
                      ifRespondsToSelector:@selector(centralManager:didRetrieveConnectedPeripherals:)
                                    object:nc
                                     block:^(NSNotification *notification) {
                                         NSArray *peripherals = notification.userInfo[WCBCNUserInfoPeripheralArray];
                                         [newDelegate centralManager:central
                                     didRetrieveConnectedPeripherals:peripherals];
                                     }];
        [self registerDelegateNotification:WCBCNDidDiscoverPeripheral
                      ifRespondsToSelector:@selector(centralManager:didDiscoverPeripheral:advertisementData:RSSI:)
                                    object:nc
                                     block:^(NSNotification *notification) {
                                         NSDictionary *userInfo = notification.userInfo;
                                         CBPeripheral *peripheral = userInfo[WCBCNUserInfoPeripheral];
                                         NSDictionary *data = userInfo[WCBCNUserInfoAdvertisementData];
                                         NSNumber *rssi = userInfo[WCBCNUserInfoRSSI];
                                         [newDelegate centralManager:central
                                               didDiscoverPeripheral:peripheral
                                                   advertisementData:data
                                                                RSSI:rssi];
                                     }];
        [self registerDelegateNotification:WCBCNDidConnectPeripheral
                      ifRespondsToSelector:@selector(centralManager:didConnectPeripheral:)
                                    object:nc
                                     block:^(NSNotification *notification) {
                                         CBPeripheral *peripheral = notification.userInfo[WCBCNUserInfoPeripheral];
                                         [newDelegate centralManager:central
                                                didConnectPeripheral:peripheral];
                                     }];
        [self registerDelegateNotification:WCBCNDidFailToConnectPeripheral
                      ifRespondsToSelector:@selector(centralManager:didFailToConnectPeripheral:error:)
                                    object:nc
                                     block:^(NSNotification *notification) {
                                         NSDictionary *userInfo = notification.userInfo;
                                         CBPeripheral *peripheral = userInfo[WCBCNUserInfoPeripheral];
                                         NSError *error = userInfo[WCBCNUserInfoError];
                                         [newDelegate centralManager:central
                                          didFailToConnectPeripheral:peripheral
                                                               error:error];
                                     }];
        [self registerDelegateNotification:WCBCNDisconnectPeripheral
                      ifRespondsToSelector:@selector(centralManager:didDisconnectPeripheral:error:)
                                    object:nc
                                     block:^(NSNotification *notification) {
                                         NSDictionary *userInfo = notification.userInfo;
                                         CBPeripheral *peripheral = userInfo[WCBCNUserInfoPeripheral];
                                         NSError *error = userInfo[WCBCNUserInfoError];
                                         [newDelegate centralManager:central
                                             didDisconnectPeripheral:peripheral
                                                               error:error];
                                     }];
    }
}

- (void)unregisterDelegate
{
    for (id<NSObject> observer in _observers) {
        [NSNC removeObserver:observer];
    }
    [_observers removeAllObjects];
}

#pragma mark - CBCentralManager forwarding

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return [WCBCentralManager sharedCentral];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector] || [[WCBCentralManager sharedCentral] respondsToSelector:aSelector];
}

+ (BOOL)instancesRespondToSelector:(SEL)aSelector
{
    return [super instancesRespondToSelector:aSelector] || [CBCentralManager instancesRespondToSelector:aSelector];
}

@end
