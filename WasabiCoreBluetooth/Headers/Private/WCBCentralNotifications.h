//
//  WCBCentralNotifications.h
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

@import Foundation;

FOUNDATION_EXPORT NSString * const WCBCNDidUpdateState;
FOUNDATION_EXPORT NSString * const WCBCNWillRestoreState;
FOUNDATION_EXPORT NSString * const WCBCNDidRetrievePeripherals;
FOUNDATION_EXPORT NSString * const WCBCNDidRetrieveConnectedPeripherals;
FOUNDATION_EXPORT NSString * const WCBCNDidDiscoverPeripheral;
FOUNDATION_EXPORT NSString * const WCBCNDidConnectPeripheral;
FOUNDATION_EXPORT NSString * const WCBCNDidFailToConnectPeripheral;
FOUNDATION_EXPORT NSString * const WCBCNDisconnectPeripheral;

FOUNDATION_EXPORT NSString * const WCBCNUserInfoPeripheral;
FOUNDATION_EXPORT NSString * const WCBCNUserInfoPeripheralArray;
FOUNDATION_EXPORT NSString * const WCBCNUserInfoAdvertisementData;
FOUNDATION_EXPORT NSString * const WCBCNUserInfoRSSI;
FOUNDATION_EXPORT NSString * const WCBCNUserInfoError;
