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
import MapKit
public class Q6JobServiceCommonLibrary
{
    
    static let q6WebApiUrl = "https://jobapi.q6.com.au/api/"
    static let q6WebApiTOKEN = "91561308-B547-4B4E-8289-D5F0B23F0037"
    
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
    
   static func getMobileDeviceToken()->String
    {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        return deviceID!
    
    }
    
    static func convertDictionaryToJSONData(dicData:[String:AnyObject])-> String
    {
        var returnString = ""
        
        do{
            
            let jsonData = try JSONSerialization.data(withJSONObject: dicData, options: [])
            
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            returnString = jsonString
            
            //      print(jsonString)
            //          returnString = jsonString.stringByReplacingOccurrencesOfString("\\",  withString:"")
            //
            //        print(returnString)
        }catch{
            
        }
        
        
        return returnString
    }
    
    static func convertStringToDateStr(DateStr: String) ->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //Your date format
        let date = dateFormatter.date(from: DateStr)
     
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .short
        myFormatter.dateFormat = "dd/MM/yyyy"
      let convertedDateStr =  myFormatter.string(from: date!)
        return convertedDateStr
        
    }
    static func getCurrentLocation()->(Double?,Double?)
    {
        let locManager = CLLocationManager()
        var currentLocation: CLLocation?
        
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways
        {
            currentLocation = locManager.location
     print( " .authorizedaways")
        }else{
           
            print("request  authorized")
            locManager.requestWhenInUseAuthorization()
            locManager.requestAlwaysAuthorization()
        }
        if currentLocation != nil
        {
        return (currentLocation!.coordinate.longitude,currentLocation!.coordinate.latitude)
        }
        else{
            return (0,0)
        }
    
    }
}
