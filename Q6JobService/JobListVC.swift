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
class JobListVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var jobListDataTableView: UITableView!
    var attachedURL = String()
    //var taskListData = JSON("")
    var byEmail:String = ""
    var isCompleted = "NO"
    var jobListData:[JobListData] = [JobListData]()
    var loginDetail:LoginDetail = LoginDetail()
    @IBOutlet weak var JobListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        jobListDataTableView.delegate = self
        jobListDataTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        JobListTableView.tableFooterView = UIView()
        let loginDetail =   Q6JobServiceDBLibrary.getLoginDetailRow()
//        do{
//            
//        }while
//        let loginDetail =   Q6JobServiceDBLibrary.getLoginDetailRow()
        byEmail = loginDetail.LoginEmail!
//
let CurrentLocation =   Q6JobServiceCommonLibrary.getCurrentLocation()
    let longitude = (String)(CurrentLocation.0! )
    let latitude =  (String)(CurrentLocation.1! )
//
//        
//        //need to change invoice to All
        let APIURL = getStaffScheduledJobList(loginDetail: loginDetail, ByEmail: byEmail, SearchText: "", longitude: longitude, latitude: latitude, JobType: "All", JobStatus: "Open", IsJobCompleted: "NO")
//
//            
//            print(APIURL)
       callGetStaffScheduledJobListWebApi(ApiUrl: APIURL)
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
              self.convertJsonToJobListDataArray(Json:swiftyJsonVar)
                
               
                print(self.jobListData)
            case .failure(let error):
                print(error)
            }
            
            
            
        }
    }
    
    func convertJsonToJobListDataArray(Json:JSON) {
        
        jobListData.removeAll()
        
        if Json.count > 0 && Json.null == nil{
            
            for  i in 0 ..< Json.count
                {
                    let jobData = JobListData()
                   jobData.JobTypeColorName = Json[i]["JobTypeColorName"].stringValue
                    jobData.UserID = Json[i]["UserID"].stringValue
                    jobData.JobCategoryColorRGBValue = Json[i]["JobCategoryColorRGBValue"].stringValue
                    jobData.JobAddress = Json[i]["JobAddress"].stringValue
                    jobData.JobID = Json[i]["JobID"].stringValue
                    jobData.JobCity = Json[i]["JobCity"].stringValue
                    jobData.LocalScheduleDate = Json[i]["LocalScheduleDate"].stringValue
                    jobData.JobType = Json[i]["JobType"].stringValue
                    jobData.DriveMinutes = Json[i]["DriveMinutes"].stringValue
                    jobData.JobTypeColorRGBValue = Json[i]["JobTypeColorRGBValue"].stringValue
                    jobData.JobTypeColorHexValue = Json[i]["JobTypeColorHexValue"].stringValue
                    jobData.LocalScheduleTime = Json[i]["LocalScheduleTime"].stringValue
                    jobData.JobCategoryColorHEXValue = Json[i]["JobCategoryColorHEXValue"].stringValue
                    jobData.JobPostalCode = Json[i]["JobPostalCode"].stringValue
                    
                    jobData.JobContactMobile = Json[i]["JobContactMobile"].stringValue
                    jobData.JobState = Json[i]["JobState"].stringValue
                    jobData.DriveDistance = Json[i]["DriveDistance"].stringValue
                    jobData.ReferenceNo = Json[i]["ReferenceNo"].stringValue
                    jobData.LocalWeekDay = Json[i]["LocalWeekDay"].stringValue
                    jobData.JobCategoryColorName = Json[i]["JobCategoryColorName"].stringValue
                     jobData.ClientName = Json[i]["ClientName"].stringValue
                    jobData.ClientID = Json[i]["ClientID"].stringValue
                jobListData.append(jobData)
            }
            
        }
        
        let jobDataListSortedByLocalScheduleDate  = self.jobListData.sorted(by: {$0.LocalScheduleDate! < $1.LocalScheduleDate!})
        let jobDataListSortedByLocalScheduleTime = jobDataListSortedByLocalScheduleDate.sorted(by: {$0.LocalScheduleTime! > $1.LocalScheduleTime!}) as [JobListData]
        
        jobListData.removeAll()
        jobListData = jobDataListSortedByLocalScheduleTime
        
        jobListDataTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print("count\( jobListData.count)")
        return  jobListData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let  cell = tableView.dequeueReusableCell(withIdentifier: "JobListTableViewCell", for: indexPath) as! JobListTableViewCell
        
        var colorHexValue =  jobListData[indexPath.row].JobTypeColorHexValue
        
        var colorRGBValue = jobListData[indexPath.row].JobTypeColorRGBValue
      
       var jobID = jobListData[indexPath.row].JobID
//        let  red = Q6JobServiceCommonLibrary.splitRBGValue(RGBString: colorRGBValue).0
//      
//        let  green   = Q6JobServiceCommonLibrary.splitRBGValue(RGBString: colorRGBValue).1
//        let  blue = Q6JobServiceCommonLibrary.splitRBGValue(RGBString: colorRGBValue).2
        let (red ,green,blue ) = Q6JobServiceCommonLibrary.splitRBGValue(RGBString: colorRGBValue)
       // print("colorHexValue \(colorHexValue)")
        print("colorRGBValue \(colorRGBValue)")
        print("jobID\(jobID)")
        if colorRGBValue != nil {
        if (colorRGBValue?.characters.count)! > 0 {
           
            print("red \(red) blue \(blue) green \(green)")
           
                cell.JobTypeColorLabel.backgroundColor = UIColor(red: CGFloat(red / 255), green:CGFloat(green / 255), blue:CGFloat(blue / 255), alpha: 1)
        // cell.JobTypeColorLabel.layer.backgroundColor = UIColor(red: 255, green: 69, blue:0, alpha: 1).cgColor
           // cell.JobTypeColorLabel.backgroundColor = UIColor(colorLiteralRed: 255, green: 609, blue: 0, alpha: 1)
        }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
