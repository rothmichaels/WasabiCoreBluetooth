//
//  WCBCentralManager.h
//  WasabiCoreBluetooth
//
//  Created by Roth Michaels on 5/27/15.
//  Copyright (c) 2015 Roth Michaels. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@protocol WCBCentralManagerDelegate;

typedef NS_ENUM(NSUInteger, WCBCentralManagerConcurrencyType) {
    WCBBluetoothQueueConcurrencyType = 0,
    WCBBackgroundConcurrencyType,
    WCBMainQueueConcurrencyType
};

@interface WCBCentralManager : NSObject

@property (weak,nonatomic) id<WCBCentralManagerDelegate> delegate;

@property (readonly) CBCentralManagerState state;

- (instancetype)initWithConcurrencyType:(WCBCentralManagerConcurrencyType)type NS_DESIGNATED_INITIALIZER;

/*!
 Initializes with WCBBluetoothQueueConcurrencyType.
 */
- (instancetype)init;

- (NSArray *)retrieveConnectedPeripheralsWithServices:(NSArray *)serviceUUIDs;

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options;

- (void)stopScan;

- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options;

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

@end

@protocol WCBCentralManagerDelegate <NSObject>

@required

- (void)centralManagerDidUpdateState:(WCBCentralManager *)central;

- (void)centralManager:(WCBCentralManager *)central willRestoreState:(NSDictionary *)dict;

- (void)centralManager:(WCBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals;

- (void)centralManager:(WCBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals;

- (void)centralManager:(WCBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;

- (void)centralManager:(WCBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;

- (void)centralManager:(WCBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

- (void)centralManager:(WCBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
@end
