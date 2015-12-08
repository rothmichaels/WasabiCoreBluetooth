//
//  WCBCentralNotificationCenter.m
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

#import "WCBCentralNotificationCenter.h"

#import "WCBCentralNotifications.h"

#define NSNC [NSNotificationCenter defaultCenter]

@implementation WCBCentralNotificationCenter

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [NSNC postNotificationName:WCBCNDidUpdateState
                        object:central];
}

- (void)centralManager:(CBCentralManager *)central
      willRestoreState:(NSDictionary *)dict
{
    [NSNC postNotificationName:WCBCNWillRestoreState
                        object:central
                      userInfo:dict];
}

- (void)centralManager:(CBCentralManager *)central
didRetrievePeripherals:(NSArray *)peripherals
{
    [NSNC postNotificationName:WCBCNDidRetrievePeripherals
                        object:central
                      userInfo:@{WCBCNUserInfoPeripheralArray: peripherals}];
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    [NSNC postNotificationName:WCBCNDidRetrieveConnectedPeripherals
                        object:central
                      userInfo:@{WCBCNUserInfoPeripheralArray: peripherals}];
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    [NSNC postNotificationName:WCBCNDidDiscoverPeripheral
                        object:central
                      userInfo:@{WCBCNUserInfoPeripheral: peripheral,
                                 WCBCNUserInfoAdvertisementData: advertisementData,
                                 WCBCNUserInfoRSSI: RSSI}];
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    [NSNC postNotificationName:WCBCNDidConnectPeripheral
                        object:central
                      userInfo:@{WCBCNUserInfoPeripheral: peripheral}];
}

FOUNDATION_STATIC_INLINE
NSDictionary *WCBUserInfoWithError(CBPeripheral *peripheral, NSError *error)
{
    return [[NSDictionary alloc] initWithObjectsAndKeys:peripheral,WCBCNUserInfoPeripheral, error, WCBCNUserInfoError, nil];
}

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    [NSNC postNotificationName:WCBCNDidFailToConnectPeripheral
                        object:central
                      userInfo:WCBUserInfoWithError(peripheral, error)];
}

- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    [NSNC postNotificationName:WCBCNDisconnectPeripheral
                        object:central
                      userInfo:WCBUserInfoWithError(peripheral, error)];
}

@end
