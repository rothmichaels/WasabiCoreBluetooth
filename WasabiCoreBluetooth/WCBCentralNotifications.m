//
//  WCBCentralNotifications.m
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

#import "WCBCentralNotifications.h"

NSString * const WCBCNDidUpdateState                    = @"WCBCentralNotification.DidUpdateState";
NSString * const WCBCNWillRestoreState                  = @"WCBCentralNotification.WillRestoreState";
NSString * const WCBCNDidRetrievePeripherals            = @"WCBCentralNotification.DidRetrievePeripherals";
NSString * const WCBCNDidRetrieveConnectedPeripherals   = @"WCBCentralNotification.DidRetrieveConnectedPeripherals";
NSString * const WCBCNDidDiscoverPeripheral             = @"WCBCentralNotification.DidDiscoverPeripheral";
NSString * const WCBCNDidConnectPeripheral              = @"WCBCentralNotification.DidConnectPeripheral";
NSString * const WCBCNDidFailToConnectPeripheral        = @"WCBCentralNotification.DidFailToConnectPeripheral";
NSString * const WCBCNDisconnectPeripheral              = @"WCBCentralNotification.DisconnectPeripheral";

NSString * const WCBCNUserInfoPeripheral                = @"peripheral";
NSString * const WCBCNUserInfoPeripheralArray           = @"peripherals";
NSString * const WCBCNUserInfoAdvertisementData         = @"data";
NSString * const WCBCNUserInfoRSSI                      = @"rssi";
NSString * const WCBCNUserInfoError                     = @"error";
