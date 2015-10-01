//
//  WCBCentralNotificationCenter.m
//  WasabiCoreBluetooth
//
//  Created by Roth Michaels on 5/27/15.
//  Copyright (c) 2015 Roth Michaels. All rights reserved.
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

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    [NSNC postNotificationName:WCBCNDidFailToConnectPeripheral
                        object:central
                      userInfo:@{WCBCNUserInfoPeripheral: peripheral,
                                 WCBCNUserInfoError: error}];
}

- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    [NSNC postNotificationName:WCBCNDisconnectPeripheral
                        object:central
                      userInfo:@{WCBCNUserInfoPeripheral: peripheral,
                                 WCBCNUserInfoError: error}];
}

@end
