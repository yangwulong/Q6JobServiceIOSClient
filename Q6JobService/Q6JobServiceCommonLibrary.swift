//
//  Q6JobServiceCommonLibrary.swift
//  Q6JobService
//
//  Created by yang wulong on 3/5/17.
//  Copyright © 2017 q6. All rights reserved.
//

import Foundation
import LocalAuthentication
import UIKit
import SystemConfiguration
public class Q6JobServiceCommonLibrary
{
    
    
    
    public static func isEmailAddressValid(email: String) -> Bool {
        
        var filterString: String
        
        filterString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", filterString)
        
        return emailTest.evaluate(with: email)
    }
    
    // changed return from [String] to String
    //addresses[0] return public IP ,addresses[1] return private ip
    static func getIPAddresses() -> String {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            repeat{
                
                let flags = Int32((ptr?.pointee.ifa_flags)!)
                var addr = ptr?.pointee.ifa_addr.pointee
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            
                            //String(
                            if let address = String(validatingUTF8: hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr?.pointee.ifa_next
                
            }while (ptr != nil)

            freeifaddrs(ifaddr)
        }
        return addresses[0]   //return public IP ,addresses[1] return private ip
    }
}
