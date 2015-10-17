//
//  WCBCentralManagerCoordinator.m
//  WasabiCoreBluetooth
//
//  Created by Roth Michaels on 10/1/15.
//  Copyright © 2015 Roth Michaels. All rights reserved.
//

#import "WCBCentralManagerCoordinator.h"

#import "WCBCentralManager.h"
#import "WCBCentralNotificationCenter.h"

@interface WCBCentralManagerCoordinator ()

@property (strong,nonatomic) NSMutableDictionary *scanRequests;
@property (strong,nonatomic) NSMutableDictionary *scanRequestOptions;
@property (strong,nonatomic) NSMutableDictionary *connectCount;

- (void)updateScanningState;

@end

@implementation WCBCentralManagerCoordinator

+ (instancetype)sharedCoordinator
{
    static WCBCentralManagerCoordinator *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[WCBCentralManagerCoordinator alloc] init];
    });
    return singleton;
}

+ (CBCentralManager *)sharedCentral
{
    static id<CBCentralManagerDelegate> delegate;
    static CBCentralManager *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [[WCBCentralNotificationCenter alloc] init];
        NSDictionary *options = nil;
        singleton = [[CBCentralManager alloc] initWithDelegate:delegate
                                                         queue:[WCBCentralManagerCoordinator bleQueue]
                                                       options:options];
    });
    return singleton;
}

+ (dispatch_queue_t)bleQueue
{
    static dispatch_queue_t singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = dispatch_queue_create("wcb.centralmanager.queue", DISPATCH_QUEUE_SERIAL);
    });
    return singleton;
}

+ (dispatch_queue_t)selfLockQueue
{
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("wcb.centralmanager.coordinator.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

- (instancetype)init
{
    if ((self = [super init])) {
        _scanRequests = [[NSMutableDictionary alloc] init];
        _scanRequestOptions = [[NSMutableDictionary alloc] init];
        _connectCount = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs
                               options:(NSDictionary *)options
                           requestedBy:(WCBCentralManager *)manager
{
    WCBCentralManagerCoordinator *__weak wself = self;
    dispatch_async([WCBCentralManagerCoordinator selfLockQueue], ^{
        NSNumber *hash = @([manager hash]);
        wself.scanRequests[hash] = (serviceUUIDs) ?: [NSNull null];
        wself.scanRequestOptions[hash] = (options) ?: [NSNull null];
        
        [wself updateScanningState];
    });
    
    
}

- (void)stopScanRequestedBy:(WCBCentralManager *)manager
{
    WCBCentralManagerCoordinator *__weak wself = self;
    dispatch_async([WCBCentralManagerCoordinator selfLockQueue], ^{
        NSNumber *hash = @([manager hash]);
        [wself.scanRequests removeObjectForKey:hash];
        [wself.scanRequestOptions removeObjectForKey:hash];
        
        [wself updateScanningState];
    });
}

- (void)updateScanningState
{
    CBCentralManager *central = [WCBCentralManagerCoordinator sharedCentral];
    NSArray *requests = [_scanRequests allValues];
    // if no reqeusts, stop scan
    if ([requests count] == 0) {
        [central stopScan];
        return;
    }
    // merge all service requests into a single set
    NSMutableArray *requestsMerged = [[NSMutableArray alloc] init];
    for (id uuids in requests) {
        if (uuids != [NSNull null]) {
            [requestsMerged addObjectsFromArray:uuids];
        }
    }
    if ([requestsMerged count]) {
        NSSet *requestSet = [[NSSet alloc] initWithArray:requestsMerged];
        requests = [requestSet allObjects];
    } else {
        requests = nil;
    }
    
    // check if we should scan for duplicates
    BOOL duplicates = NO;
    for (id options in [_scanRequestOptions allValues]) {
        if (options != [NSNull null]) {
            if ([options[CBCentralManagerScanOptionAllowDuplicatesKey] boolValue]) {
                duplicates = YES;
            }
        }
    }
    
    [central scanForPeripheralsWithServices:requests
                                    options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @(duplicates)}];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options
{
    WCBCentralManagerCoordinator *__weak ws = self;
    dispatch_async([WCBCentralManagerCoordinator selfLockQueue], ^{
        NSMutableDictionary *connectCounts = ws.connectCount;
        NSUUID *identifier = peripheral.identifier;
        NSInteger count = [connectCounts[identifier] integerValue];
        connectCounts[identifier] = @(count + 1);
        [[WCBCentralManagerCoordinator sharedCentral] connectPeripheral:peripheral options:options];
    });
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral
{
    WCBCentralManagerCoordinator *__weak ws = self;
    dispatch_async([WCBCentralManagerCoordinator selfLockQueue], ^{
        NSMutableDictionary *connectCounts = ws.connectCount;
        NSUUID *identifier = peripheral.identifier;
        NSInteger count = [connectCounts[identifier] integerValue];
        if (count == 0) {
            return;
        }
        count = count - 1;
        connectCounts[identifier] = @(count);
        if (count == 0) {
            [[WCBCentralManagerCoordinator sharedCentral] cancelPeripheralConnection:peripheral];
        }
    });
}

#pragma mark - CBCentralManager forwarding

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return [WCBCentralManagerCoordinator sharedCentral];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector] || [[WCBCentralManagerCoordinator sharedCentral] respondsToSelector:aSelector];
}

+ (BOOL)instancesRespondToSelector:(SEL)aSelector
{
    return [super instancesRespondToSelector:aSelector] || [CBCentralManager instancesRespondToSelector:aSelector];
}
@end
