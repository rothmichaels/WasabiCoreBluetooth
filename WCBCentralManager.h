//
//  WCBCentralManager.h
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
