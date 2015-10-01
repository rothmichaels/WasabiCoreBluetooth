//
//  WCBPeripheral.m
//  WasabiCoreBluetooth
//
//  Created by Roth Michaels on 10/1/15.
//  Copyright © 2015 Roth Michaels. All rights reserved.
//

#import "WCBPeripheral.h"

@interface WCBPeripheral ()

@property (weak,readwrite,atomic) CBPeripheral *peripheral;

@end

@implementation WCBPeripheral

+ (instancetype)peripheralWithPeripheral:(CBPeripheral *)peripheral
{
    return nil;
}

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral
{
    if ((self = [super init])) {
        self.peripheral = peripheral;
    }
    return self;
}

+ (NSString *)name
{
    
}

#pragma mark - Delegate

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
    
}

@end