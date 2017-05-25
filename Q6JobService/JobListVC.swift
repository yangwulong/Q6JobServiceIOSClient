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
class JobListVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var newActionView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var jobListSearchBar: JobSearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var jobListDataTableView: UITableView!
    var attachedURL = String()
    //var taskListData = JSON("")
    var byEmail:String = ""
    var isCompleted = "NO"
    var jobListData:[JobListData] = [JobListData]()
    var loginDetail:LoginDetail = LoginDetail()
    var longitude = String()
    var latitude = String()
    var JobType = "All"
    var JobStatus = "Open"
    var CurrentLocation:(Double?,Double?)
    var IsJobCompleted = "NO"

    override func viewWillAppear(_ animated: Bool) {
        newActionView.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobListDataTableView.delegate = self
        jobListDataTableView.dataSource = self
        jobListSearchBar.delegate = self
        
        // Do any additional setup after loading the view.
        
        jobListDataTableView.tableFooterView = UIView()
        loginDetail =   Q6JobServiceDBLibrary.getLoginDetailRow()
        byEmail = loginDetail.LoginEmail!
        //
        CurrentLocation =   Q6JobServiceCommonLibrary.getCurrentLocation()
        longitude = (String)(CurrentLocation.0! )
        latitude =  (String)(CurrentLocation.1! )
        //
        //
        //        //need to change invoice to All
        let APIURL = getStaffScheduledJobList(loginDetail: loginDetail, ByEmail: byEmail, SearchText: "", longitude: longitude, latitude: latitude, JobType: JobType, JobStatus: JobStatus, IsJobCompleted: IsJobCompleted)
        //
        //
        print(APIURL)
        callGetStaffScheduledJobListWebApi(ApiUrl: APIURL)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
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
        activityIndicator.stopAnimating()
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
        
        
        // Setup JobTypeColorRGBValue
        // var colorHexValue =  jobListData[indexPath.row].JobTypeColorHexValue
        
        var JobTypecolorRGBValue = jobListData[indexPath.row].JobTypeColorRGBValue
        
        
        let (JobTypeRed ,JobTypeGreen,JobTypeBlue ) = Q6JobServiceCommonLibrary.splitRBGValue(RGBString: JobTypecolorRGBValue)
        
        print("colorRGBValue \(String(describing: JobTypecolorRGBValue))")
        
        if JobTypecolorRGBValue != nil {
            if (JobTypecolorRGBValue?.characters.count)! > 0 {
                
                print("red \(JobTypeRed) blue \(JobTypeBlue) green \(JobTypeGreen)")
                
                cell.JobTypeColorLabel.backgroundColor = UIColor(red: CGFloat(JobTypeRed / 255), green:CGFloat(JobTypeGreen / 255), blue:CGFloat(JobTypeBlue / 255), alpha: 1)
            }
        }
        //Setup JobCategoryColorRGBValue
        
        var JobCategorycolorRGBValue = jobListData[indexPath.row].JobCategoryColorRGBValue
        
        
        let (JobCategoryRed ,JobCategoryGreen,JobCategoryBlue ) = Q6JobServiceCommonLibrary.splitRBGValue(RGBString: JobCategorycolorRGBValue)
        
        print("colorRGBValue \(String(describing: JobCategorycolorRGBValue))")
        
        if JobCategorycolorRGBValue != nil {
            if (JobCategorycolorRGBValue?.characters.count)! > 0 {
                
                print("red \(JobCategoryRed) blue \(JobCategoryBlue) green \(JobCategoryGreen)")
                
                cell.JobCategoryColor.backgroundColor = UIColor(red: CGFloat(JobCategoryRed / 255), green:CGFloat(JobCategoryGreen / 255), blue:CGFloat(JobCategoryBlue / 255), alpha: 1)
                
                
            }
        }
        
        //Setup ClientName
        
        let clientName = jobListData[indexPath.row].ClientName
        cell.ClientName.text = clientName
        
        // Setup AddressLine1
        let JobAddress = jobListData[indexPath.row].JobAddress == nil ? "" : jobListData[indexPath.row].JobAddress!
        let JobAddressLine2 = jobListData[indexPath.row].JobAddressLine2 == nil ? "" : jobListData[indexPath.row].JobAddressLine2!
        let JobAddressCity = jobListData[indexPath.row].JobCity == nil ? "" : jobListData[indexPath.row].JobCity!
        
        
        cell.AddressLine1.text = JobAddress + " " + JobAddressLine2 + " " + JobAddressCity
        
        //Setup AddressLine2
        
        let JobPostalCode = jobListData[indexPath.row].JobPostalCode == nil ? "" : jobListData[indexPath.row].JobPostalCode!
        
        let JobAddressState  = jobListData[indexPath.row].JobState == nil ? "" : jobListData[indexPath.row].JobState!
        cell.AddressLine2.text = JobAddressState + " " + JobPostalCode
        
        //setup drivemin,drivekilo
        let driveMinutes = jobListData[indexPath.row].DriveMinutes == nil ? "0" : jobListData[indexPath.row].DriveMinutes!
        let driveDistance = jobListData[indexPath.row].DriveDistance == nil ? "0" : jobListData[indexPath.row].DriveDistance!
        
        cell.DriveMinWithDrivekilo.text = driveMinutes + "min -" + driveDistance + "km"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        callJoblistByUserWebApiFromSearchBar()
        jobListSearchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        callJoblistByUserWebApiFromSearchBar()
        jobListSearchBar.resignFirstResponder()
    }
    
    func callJoblistByUserWebApiFromSearchBar(){
        
        let searchBarText = jobListSearchBar.text
        
        if (searchBarText?.characters.count)! > 0
        {
            setAttachedURL(ByEmail: byEmail, SearchText: searchBarText!, Longitude:longitude, Latitude: latitude, JobType: JobType, JobStatus: JobStatus ,IsJobCompleted: IsJobCompleted)
            
            let loginDetail =   Q6JobServiceDBLibrary.getLoginDetailRow()
            byEmail = loginDetail.LoginEmail!
            let APIURL = getStaffScheduledJobList(loginDetail: loginDetail, ByEmail: byEmail, SearchText: searchBarText!, longitude: longitude, latitude: latitude, JobType: JobType, JobStatus: JobStatus, IsJobCompleted: IsJobCompleted)
            
            callGetStaffScheduledJobListWebApi(ApiUrl: APIURL)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        jobListSearchBar.resignFirstResponder()
    }
    @IBAction func AddBarButtonClick(_ sender: Any) {
        
 
        setupNewActionViewSizePosition()

    }
    
    func setupNewActionViewSizePosition()
    {
       let ScreenSize: CGRect = UIScreen.main.bounds
//        
//        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
//        
//        
//        let xPosition = newActionView.frame.origin.x
//        
//        //View will slide 20px up
//        let yPosition = newActionView.frame.origin.y - 20
//        
////         newActionView.frame.size.height = screenHeight
////        newActionView.frame.size.width = screenWidth
//        newActionView.frame.size = CGSize(width: screenWidth, height: screenHeight)
//        UIView.animate(withDuration: 1.0, animations: {
//            
//            self.newActionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//            
//            self.cancelButton.frame = CGRect(x:160 ,y:300 ,width: self.cancelButton.frame.width,height:self.cancelButton.frame.height)
//            
//        })
        
        //intially set x = SCREEN_WIDTH
        newActionView.frame = CGRect(x:0, y: ScreenSize.height , width: ScreenSize.width, height: ScreenSize.height )
        
        UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            //Set x position what ever you want
            self.newActionView.isHidden = false
           self.newActionView.frame = CGRect(x: 0, y: 0 , width: ScreenSize.width, height: ScreenSize.height )
            
        }, completion: nil)
    }
    @IBAction func CancelButtonClick(_ sender: Any) {
        newActionView.isHidden = true
    }
}
