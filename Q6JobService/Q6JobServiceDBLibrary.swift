//
//  Q6JobServiceDBLibrary.swift
//  Q6JobService
//
//  Created by yang wulong on 10/5/17.
//  Copyright © 2017 q6. All rights reserved.
//

import Foundation
import SQLite

class Q6JobServiceDBLibrary{
    
    
    
    static func createDB(){
        do{
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            print(path)
            let db = try Connection("\(path)/Q6JobServiceDB.sqlite3")
        }catch
        {
        }
        
    }
    
    static func createUserLoginTable(){
        
        do{
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            print(path)
            let db = try Connection("\(path)/Q6JobServiceDB.sqlite3")
            
            let userLogin = Table("userLogin")
            
            let userLoginId = Expression<Int64>("userLoginId")
            let LoginEmail = Expression<String>("LoginEmail")
            let LoginPassword = Expression<String>("LoginPassword")
            let WebApiToken = Expression<String>("WebApiToken")
            let LoginDateTime = Expression<String>("LoginDateTime")
            let MobileDeviceToken = Expression<String>("MobileDeviceToken")
            
            try db.run(userLogin.create(ifNotExists: true) { t in
                t.column(userLoginId,primaryKey: .autoincrement) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(LoginEmail)  //     "email" TEXT UNIQUE NOT NULL,
                t.column(LoginPassword)
                t.column(WebApiToken)
                t.column(LoginDateTime)
                t.column(MobileDeviceToken)
                
                
            })
        }
        catch{
            
        }
    }
    
    
    static func VerifyHasDataInUserLoginTable() -> Bool{
        
        var hasData:Bool = false
        do{
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            print(path)
            let db = try Connection("\(path)/Q6JobServiceDB.sqlite3")
            
            let userLogin = Table("userLogin")
            
            if let userLogin = try db.pluck(userLogin) {
            
            hasData = true
            } // Row
            
            
     
        }
        catch{
            
        }
        
        return hasData
    }
    static func insertUserLoginrow(_LoginEmail:String,_LoginPassword:String,_WebApiToken:String,_LoginDateTime:String,_MobileDeviceToken:String)
    {
        do{
            
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            print(path)
            let db = try Connection("\(path)/Q6JobServiceDB.sqlite3")
            
            let userLogin = Table("userLogin")
            
            //delete data row first
            try db.run(userLogin.delete())
           // let userLoginId = Expression<Int64>("userLoginId")
            let LoginEmail = Expression<String>("LoginEmail")
            let LoginPassword = Expression<String>("LoginPassword")
            let WebApiToken = Expression<String>("WebApiToken")
            let LoginDateTime = Expression<String>("LoginDateTime")
            let MobileDeviceToken = Expression<String>("MobileDeviceToken")
            
            try db.run(userLogin.insert(or: .replace, LoginEmail <- _LoginEmail, LoginPassword <- _LoginPassword,WebApiToken <- _WebApiToken,LoginDateTime <- _LoginDateTime, MobileDeviceToken <- _MobileDeviceToken))
            
        }catch{
            
        }
    }
    
    static func getLoginDetailRow() ->LoginDetail
    {
        
        var loginDetail = LoginDetail()
        
        do{
            
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            print(path)
            let db = try Connection("\(path)/Q6JobServiceDB.sqlite3")
            
            let userLogin = Table("userLogin")
            
            let LoginEmail = Expression<String>("LoginEmail")
            let LoginPassword = Expression<String>("LoginPassword")
            
            for userLogin in try db.prepare(userLogin.select(LoginEmail, LoginPassword)) {
                loginDetail.LoginEmail = userLogin[LoginEmail]
                loginDetail.LoginPassword = userLogin[LoginPassword]
                print("id: \(userLogin[LoginEmail]), email: \(userLogin[LoginPassword])")
                // id: 1, email: alice@mac.com
            }
            
        }catch{
            
        }
        return loginDetail
    }
}


