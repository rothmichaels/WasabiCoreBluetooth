//
//  WCBTypes.h
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

#ifndef WCBTypes_h
#define WCBTypes_h

typedef NS_ENUM(NSUInteger, WCBCentralManagerConcurrencyType) {
    WCBBluetoothQueueConcurrencyType = 0,
    WCBBackgroundConcurrencyType,
    WCBMainQueueConcurrencyType
};

#endif