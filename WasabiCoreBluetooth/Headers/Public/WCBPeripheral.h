//
//  WCBPeripheral.h
//  WasabiCoreBluetooth
//
//  Created by Roth Michaels on 10/1/15.
//  Copyright © 2015 Roth Michaels. All rights reserved.
//

@import CoreBluetooth;

@protocol WCBPeripheralDelegate;

/*!
 @class WCBPeripheral
 @discussion
    Wraps a CBPeripheral to allow for multiple delegates.
 */
@interface WCBPeripheral : NSObject

/*!
 @property 
 @discussion
 */
@property (weak,nonatomic) id<WCBPeripheralDelegate> delegate;

@property (weak,readonly,atomic) CBPeripheral *peripheral;


+ (instancetype)peripheralWithPeripheral:(CBPeripheral *)peripheral;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;


@property (readonly) NSString *name;
@property (readonly) CBPeripheralState state;
@property (readonly) NSArray<CBService *> *services;

- (void)readRSSI;

- (void)discoverServices:(NSArray *)serviceUUIDs;

- (void)discoverIncludedServices:(NSArray *)includedServiceUUIDs
                      forService:(CBService *)service;

- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs
                     forService:(CBService *)service;

- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic;

- (void)writeValue:(NSData *)data
 forCharacteristic:(CBCharacteristic *)characteristic
              type:(CBCharacteristicWriteType)type;

- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic;

- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic;

- (void)readValueForDescriptor:(CBDescriptor *)descriptor;

- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor;

@end

@protocol WCBPeripheralDelegate <NSObject>

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral;

- (void)peripheral:(CBPeripheral *)peripheral
 didModifyServices:(NSArray *)invalidatedServices;

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:( NSError *)error;

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:( NSError *)error;

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:( NSError *)error;

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:( NSError *)error;

 - (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:( NSError *)error;

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:( NSError *)error;

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:( NSError *)error;

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:( NSError *)error;

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:( NSError *)error;

@end