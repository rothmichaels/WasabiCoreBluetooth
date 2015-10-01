//
//  WCBCentralNotifications.h
//  WasabiCoreBluetooth
//
//  Created by Roth Michaels on 5/27/15.
//  Copyright (c) 2015 Roth Michaels. All rights reserved.
//

#import <Foundation/Foundation.h>

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