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

@import CoreBluetooth;

#import "WCBTypes.h"

@protocol WCBCentralManagerDelegate;

/*!
 @class WCBCentralManager
 @discussion
    Each instance provides an interface to a CBCentralManager
    singleton allowing individual instances to monitor
    their own scan requests.
 */
@interface WCBCentralManager : NSObject

/*!
 @property delegate
 @discussion The delegate object that will receive central events. 
 */
@property (weak,nonatomic) id<WCBCentralManagerDelegate> delegate;

/*!
 @property state
 @discussion Current BLE Radio Central state.
 */
@property (readonly,nonatomic) CBCentralManagerState state;

/*!
 @property scanning
 @discussion True if the singleton CBCentralManager is currently scanning.
 */
@property (readonly,nonatomic,getter=isScanning) BOOL scanning;

/*!
 Initialize a WCBCentralManager instance with a specific concurrency 
 type.  The concurrency type determines the GCD dispatch queue that 
 WCBCentralManagerDelegate method calls will be performed on.
 
 @param type
    Concurrency type
 
    WCBBluetoothQueueConcurrencyType    CoreBluetooth background queue
    WCBBackgroundConcurrencyType        Global current dispatch qeueue
    WCBMainQueueConcurrencyType         Main thread dispatch queue
*/
- (instancetype)initWithConcurrencyType:(WCBCentralManagerConcurrencyType)type NS_DESIGNATED_INITIALIZER;

/*!
 Initializes with WCBBluetoothQueueConcurrencyType.
 */
- (instancetype)init;

/*!
 Pause all BLE Peripheral scanning for all requests
 submitted by WCBBluetoothCentralManager instances.
 */
+ (void)pauseScan;
/*!
 Resume paused BLE Peripheral scanning for all requests
 submitted by WCBBluetoothCentralManager instances.
 */
+ (void)resumeScan;

#pragma mark -
// CBCentralManager forwarded method calls

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options;

- (void)stopScan;

- (NSArray *)retrievePeripheralsWithIdentifiers:(NSArray *)identifiers;

- (NSArray *)retrieveConnectedPeripheralsWithServices:(NSArray *)serviceUUIDs;

- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options;

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

@end

/*!
 @protocol WCBCentralManagerDelegate
 @discussion
    Delegate methods triggered by notifications from
    the singleton CBCentralManager delegate.
 */
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
