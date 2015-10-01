//
//  WCBCentralManagerCoordinator.h
//  WasabiCoreBluetooth
//
//  Created by Roth Michaels on 10/1/15.
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

@class WCBCentralManager;

/*!
 @class WCBCentralManagerCoordinator
 @discussion
    Manages scan requests made by WCBCentralManager instances
    so that the singleton CBCentralManager is always scanning
    for the necessary services.
 */
@interface WCBCentralManagerCoordinator : NSObject

/*!
 Shared singleton WCBCentralManagerCoordinator instance.
 
 @returns The singleton.
 */
+ (instancetype)sharedCoordinator;

/*
 Shared CBCentralManager instance.
 
 @returns The singleton.
 */
+ (CBCentralManager *)sharedCentral;

/*!
 Returns GCD Queue used by the CBCentralManager
 and WCBCentralManagerCoordinator.
 
 @returns BLE Central GCD Dispatch Queue.
 */
+ (dispatch_queue_t)bleQueue;

/*!
 Starts scanning for BLE Peripheral devices.  If scanning was
 already started by another instance, the service list and options
 are merged with values from previous scan requests.
 
 If this method is called multiple times before calling
 -stopScanRequestedBy:, the previous scan request values
 will be replaced by the values in this call.
 
 @param serviceUUIDs
    Array of CBUUIDs identifying pheriphal services to scan for.
    Passing nil will cause scan for all nearby services.
 @param options
    Dictionary of CBCentralManager options.
    N.B.: Currnetly `CBCentralManagerScanOptionAllowDuplicatesKey`
    is the only supported option.
 @param manager
    Reference to the requesting WCBCentralManager instance
    so that this request can be matched with later stop requests.
 */
- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs
                               options:(NSDictionary *)options
                           requestedBy:(WCBCentralManager *)manager;

/*!
 Stop the BLE Peripheral service scan request previously started
 by manager.  If the scan
 
 @param manager
    The instance whose previous scan request should be stopped.
 */
- (void)stopScanRequestedBy:(WCBCentralManager *)manager;

#pragma mark -
// CBCentralManager forwarded method calls

- (NSArray *)retrievePeripheralsWithIdentifiers:(NSArray *)identifiers;

- (NSArray *)retrieveConnectedPeripheralsWithServices:(NSArray *)serviceUUIDs;

- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options;

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

@end