//
//  TaskListTabVC.swift
//  Q6JobService
//
//  Created by yang wulong on 15/5/17.
//  Copyright © 2017 q6. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class TaskListTabVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    
    @IBOutlet weak var taskListSearchBar: TaskSearchBar!
    @IBOutlet weak var taskListTableView: UITableView!
    var attachedURL = String()
    var taskListData = JSON("")
    var byEmail:String = ""
    var isCompleted = "NO"
    //
    //    https://jobapi.q6.com.au/api/Job/GetTaskListByUser?Jsonlogin={"LoginName":"yange%40uniware.com.au","ClientIP":null,"Password":"richman58.","MobileDeviceToken":null,"WebApiTOKEN":"91561308-b547-4b4e-8289-d5f0b23f0037"}&byEmail=254521565@qq.com&SearchText=1112&IsCompleted=NO
    //
    
    override func viewDidLoad() {
        taskListTableView.dataSource = self
        taskListTableView.delegate = self
        taskListSearchBar.delegate = self
        
        //remove empty cell from tableView
        taskListTableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        let loginDetail =   Q6JobServiceDBLibrary.getLoginDetailRow()
        byEmail = loginDetail.LoginEmail!
        let apiUrl = getTasklistByUserUrl(loginDetail: loginDetail, byEmail: byEmail, searchText:"", isCompleted: isCompleted)
        
        print(apiUrl)
        callTasklistByUserWebApi(ApiUrl: apiUrl)
        
        

    }
    
    func callTasklistByUserWebApi(ApiUrl:String)
    {
        Alamofire.request(ApiUrl).validate().responseJSON { response in
            
            switch response.result {
                
                
            case .success(let value):
                
                let swiftyJsonVar = JSON(value)
                let resultsArray = swiftyJsonVar.arrayValue
                
                let sortedResults = resultsArray.sorted { $0["JobTaskDueDate"].doubleValue < $1["JobTaskDueDate"].doubleValue }
                
                self.taskListData = JSON(sortedResults)
                self.taskListTableView.reloadData()
                print(swiftyJsonVar)
            case .failure(let error):
                print(error)
            }
            
            
            
        }
    }
    func getTasklistByUserUrl(loginDetail: LoginDetail,byEmail:String,searchText:String ,isCompleted:String) -> String{
        
        let _baseWebApiUrl = Q6JobServiceCommonLibrary.q6WebApiUrl
        
        
        
        
        var _loginDetail = [String:String]()
        
        _loginDetail["LoginName"] = loginDetail.LoginEmail!
        _loginDetail["Password"] = loginDetail.LoginPassword!
        _loginDetail["WebApiTOKEN"] = Q6JobServiceCommonLibrary.getMobileDeviceToken()
        _loginDetail["ClientIP"] = Q6JobServiceCommonLibrary.getIPAddresses()
        _loginDetail["MobileDeviceToken"] = Q6JobServiceCommonLibrary.getMobileDeviceToken()
        
        
        
        let jasonLoginDeail = Q6JobServiceCommonLibrary.convertDictionaryToJSONData(dicData: _loginDetail as [String : AnyObject])
        setAttachedURL(ByEmail: byEmail, SearchText: searchText, IsCompleted: isCompleted)
        
        let EncodeAttachedURL = (jasonLoginDeail + attachedURL).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed )! as String
        
        
        //apiUrl = _baseWebApiUrl  + "/job/GetTaskList?Jsonlogin={LoginName:"
        let url : String = _baseWebApiUrl + "Job/GetTaskListByUser?Jsonlogin="  + EncodeAttachedURL
        
        
        let replacedApiUrl = url.replacingOccurrences(of: "\\", with:"" )
        //
        return replacedApiUrl
    }
    
    //    https://jobapi.q6.com.au/api/Job/GetTaskListByUser?Jsonlogin={"LoginName":"yange%40uniware.com.au","ClientIP":null,"Password":"richman58.","MobileDeviceToken":null,"WebApiTOKEN":"91561308-b547-4b4e-8289-d5f0b23f0037"}&byEmail=254521565@qq.com&SearchText=1112&IsCompleted=NO
    //
    
    func setAttachedURL(ByEmail: String , SearchText:String,IsCompleted:String )
    {
        attachedURL = "&byEmail=" + ByEmail + "&SearchText=" + SearchText + "&IsCompleted=" + "NO"
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableCell", for: indexPath) as! TaskListTableCell
        
        cell.JobReferenceNO.text = taskListData[indexPath.row]["ReferenceNo"].stringValue
        
        let dueDateStr = taskListData[indexPath.row]["JobTaskDueDate"].stringValue
        
        cell.DueDate.text = Q6JobServiceCommonLibrary.convertStringToDateStr(DateStr: dueDateStr)
      //  cell.StaffName.text = taskListData[indexPath.row]["JobTaskAssignToUserName"].stringValue
        
      //  cell.TaskDetail.text = taskListData[indexPath.row]["JobTaskDetail"].stringValue
        //        cell.lblContactID.isHidden = true
        //
        //
        //        cell.lblContactName.text =  contactData[indexPath.row].ContactName
        //        cell.lblContactID.text =  contactData[indexPath.row].ContactID
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
       callTasklistByUserWebApiFromSearchBar()
    }
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        callTasklistByUserWebApiFromSearchBar()
    }
    
    func callTasklistByUserWebApiFromSearchBar(){
        
        let searchBarText = taskListSearchBar.text
        
        if (searchBarText?.characters.count)! > 0
        {
          setAttachedURL(ByEmail: byEmail, SearchText: searchBarText!, IsCompleted: isCompleted)
            
            let loginDetail =   Q6JobServiceDBLibrary.getLoginDetailRow()
            byEmail = loginDetail.LoginEmail!
            let apiUrl = getTasklistByUserUrl(loginDetail: loginDetail, byEmail: byEmail, searchText:searchBarText!, isCompleted: isCompleted)
            
            callTasklistByUserWebApi(ApiUrl: apiUrl)
        }
    }
}
