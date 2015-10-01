//
//  WCBCentralNotifications.m
//  WasabiCoreBluetooth
//
//  Created by Roth Michaels on 5/27/15.
//  Copyright (c) 2015 Roth Michaels. All rights reserved.
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