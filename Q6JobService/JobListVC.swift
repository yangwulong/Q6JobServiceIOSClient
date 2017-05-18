//
//  JobsVC.swift
//  Q6JobService
//
//  Created by yang wulong on 9/5/17.
//  Copyright © 2017 q6. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class JobListVC: UIViewController {

    var attachedURL = String()
    //var taskListData = JSON("")
    var byEmail:String = ""
    var isCompleted = "NO"
    var jobListData:[JobListData] = [JobListData]()
    var loginDetail:LoginDetail = LoginDetail()
    @IBOutlet weak var JobListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        JobListTableView.tableFooterView = UIView()
        let loginDetail =   Q6JobServiceDBLibrary.getLoginDetailRow()
//        do{
//            
//        }while
//        let loginDetail =   Q6JobServiceDBLibrary.getLoginDetailRow()
        byEmail = loginDetail.LoginEmail!
//
//let CurrentLocation =   Q6JobServiceCommonLibrary.getCurrentLocation()
//    let longitude = (String)(CurrentLocation.0! )
//    let latitude =  (String)(CurrentLocation.1! )
//        
//        
//        //need to change invoice to All
//        let APIURL = getStaffScheduledJobList(loginDetail: loginDetail, ByEmail: byEmail, SearchText: "", longitude: longitude, latitude: latitude, JobType: "All", JobStatus: "Open", IsJobCompleted: "NO")
//        
//            
//            print(APIURL)
//        callGetStaffScheduledJobListWebApi(ApiUrl: APIURL)
    }

//https://jobapi.q6.com.au/api/Job/GetStaffScheduledJobList?Jsonlogin={"LoginName":"yange%40uniware.com.au","ClientIP":null,"Password":"richman58.","MobileDeviceToken":null,"WebApiTOKEN":"91561308-b547-4b4e-8289-d5f0b23f0037"}&byEmail=yange@uniware.com.au&longitude=145.17805780000003&latitude=-37.8196608&SearchText=&JobType=Invoice&JobStatus=Open&IsJobCompleted=NO
    func getStaffScheduledJobList(loginDetail: LoginDetail,ByEmail: String , SearchText:String,longitude:String,latitude:String,JobType:String,JobStatus:String,IsJobCompleted:String ) -> String{
        
        let _baseWebApiUrl = Q6JobServiceCommonLibrary.q6WebApiUrl
        
        
        
        
        var _loginDetail = [String:String]()
        
        _loginDetail["LoginName"] = loginDetail.LoginEmail!
        _loginDetail["Password"] = loginDetail.LoginPassword!
        _loginDetail["WebApiTOKEN"] = Q6JobServiceCommonLibrary.getMobileDeviceToken()
        _loginDetail["ClientIP"] = Q6JobServiceCommonLibrary.getIPAddresses()
        _loginDetail["MobileDeviceToken"] = Q6JobServiceCommonLibrary.getMobileDeviceToken()
        
        
        
        let jasonLoginDeail = Q6JobServiceCommonLibrary.convertDictionaryToJSONData(dicData: _loginDetail as [String : AnyObject])
        setAttachedURL(ByEmail: ByEmail , SearchText:SearchText,Longitude:longitude,Latitude:latitude,JobType:JobType,JobStatus:JobStatus,IsJobCompleted:IsJobCompleted )
        
        let EncodeAttachedURL = (jasonLoginDeail + attachedURL).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed )! as String
        
        
        //apiUrl = _baseWebApiUrl  + "/job/GetTaskList?Jsonlogin={LoginName:"
        let url : String = _baseWebApiUrl + "Job/GetStaffScheduledJobList?Jsonlogin="  + EncodeAttachedURL
        
        
        let replacedApiUrl = url.replacingOccurrences(of: "\\", with:"" )
        //
        return replacedApiUrl
    }
    
  //https://jobapi.q6.com.au/api/Job/GetStaffScheduledJobList?Jsonlogin={"LoginName":"yange%40uniware.com.au","ClientIP":null,"Password":"richman58.","MobileDeviceToken":null,"WebApiTOKEN":"91561308-b547-4b4e-8289-d5f0b23f0037"}&byEmail=yange@uniware.com.au&longitude=145.17805780000003&latitude=-37.8196608&SearchText=&JobType=Invoice&JobStatus=Open&IsJobCompleted=NO
    
    func setAttachedURL(ByEmail: String , SearchText:String,Longitude:String,Latitude:String,JobType:String,JobStatus:String,IsJobCompleted:String )
    {
        attachedURL = "&byEmail=" + ByEmail + "&SearchText=" + SearchText + "&longitude=" + Longitude + "&latitude=" + Latitude + "&JobType=" + JobType + "&JobStatus=" + JobStatus  + "&IsJobCompleted=" + "NO"
    }
    func callGetStaffScheduledJobListWebApi(ApiUrl:String)
    {
        Alamofire.request(ApiUrl).validate().responseJSON { response in
            
            switch response.result {
                
                
            case .success(let value):
                
                let swiftyJsonVar = JSON(value)
//                let resultsArray = swiftyJsonVar.arrayValue
//                
//                let sortedResults = resultsArray.sorted { $0["JobTaskDueDate"].doubleValue < $1["JobTaskDueDate"].doubleValue }
//                
//                self.taskListData = JSON(sortedResults)
//                self.taskListTableView.reloadData()
                print(swiftyJsonVar)
            case .failure(let error):
                print(error)
            }
            
            
            
        }
    }

}
