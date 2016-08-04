//
//  UIDevice+KYSAddition.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "UIDevice+KYSAddition.h"
#include <net/if.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <libkern/OSAtomic.h>

@implementation UIDevice (KYSAddition)

- (NSString *)ipAddressWIFI {
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

- (NSString *)ipAddressCell {
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}


typedef struct {
    uint64_t en_in;
    uint64_t en_out;
    uint64_t pdp_ip_in;
    uint64_t pdp_ip_out;
    uint64_t awdl_in;
    uint64_t awdl_out;
} yy_net_interface_counter;


static uint64_t yy_net_counter_add(uint64_t counter, uint64_t bytes) {
    if (bytes < (counter % 0xFFFFFFFF)) {
        counter += 0xFFFFFFFF - (counter % 0xFFFFFFFF);
        counter += bytes;
    } else {
        counter = bytes;
    }
    return counter;
}

static uint64_t yy_net_counter_get_by_type(yy_net_interface_counter *counter, YYNetworkTrafficType type) {
    uint64_t bytes = 0;
    if (type & YYNetworkTrafficTypeWWANSent) bytes += counter->pdp_ip_out;
    if (type & YYNetworkTrafficTypeWWANReceived) bytes += counter->pdp_ip_in;
    if (type & YYNetworkTrafficTypeWIFISent) bytes += counter->en_out;
    if (type & YYNetworkTrafficTypeWIFIReceived) bytes += counter->en_in;
    if (type & YYNetworkTrafficTypeAWDLSent) bytes += counter->awdl_out;
    if (type & YYNetworkTrafficTypeAWDLReceived) bytes += counter->awdl_in;
    return bytes;
}

static yy_net_interface_counter yy_get_net_interface_counter() {
    static OSSpinLock lock = OS_SPINLOCK_INIT;
    static NSMutableDictionary *sharedInCounters;
    static NSMutableDictionary *sharedOutCounters;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInCounters = [NSMutableDictionary new];
        sharedOutCounters = [NSMutableDictionary new];
    });
    
    yy_net_interface_counter counter = {0};
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;
        OSSpinLockLock(&lock);
        while (cursor) {
            if (cursor->ifa_addr->sa_family == AF_LINK) {
                const struct if_data *data = cursor->ifa_data;
                NSString *name = cursor->ifa_name ? [NSString stringWithUTF8String:cursor->ifa_name] : nil;
                if (name) {
                    uint64_t counter_in = ((NSNumber *)sharedInCounters[name]).unsignedLongLongValue;
                    counter_in = yy_net_counter_add(counter_in, data->ifi_ibytes);
                    sharedInCounters[name] = @(counter_in);
                    
                    uint64_t counter_out = ((NSNumber *)sharedOutCounters[name]).unsignedLongLongValue;
                    counter_out = yy_net_counter_add(counter_out, data->ifi_obytes);
                    sharedOutCounters[name] = @(counter_out);
                    
                    if ([name hasPrefix:@"en"]) {
                        counter.en_in += counter_in;
                        counter.en_out += counter_out;
                    } else if ([name hasPrefix:@"awdl"]) {
                        counter.awdl_in += counter_in;
                        counter.awdl_out += counter_out;
                    } else if ([name hasPrefix:@"pdp_ip"]) {
                        counter.pdp_ip_in += counter_in;
                        counter.pdp_ip_out += counter_out;
                    }
                }
            }
            cursor = cursor->ifa_next;
        }
        OSSpinLockUnlock(&lock);
        freeifaddrs(addrs);
    }
    
    return counter;
}

- (uint64_t)getNetworkTrafficBytes:(YYNetworkTrafficType)types {
    yy_net_interface_counter counter = yy_get_net_interface_counter();
    return yy_net_counter_get_by_type(&counter, types);
}

@end
