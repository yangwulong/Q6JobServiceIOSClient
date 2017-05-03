//
//  ViewController.swift
//  Q6JobService
//
//  Created by yang wulong on 3/4/17.
//  Copyright © 2017 q6. All rights reserved.
//

import UIKit

class LoginVC: UIViewController ,UITextFieldDelegate{

    var activeField: UITextField?
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtLoginEmail: UITextField!
    
    @IBOutlet weak var txtLoginPassword: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override open func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    
    
    
    @IBAction func TapGuestureREcoginizerEvent(_ sender: Any) {
        txtLoginEmail.resignFirstResponder()
        txtLoginPassword.resignFirstResponder()
        scrollView.isScrollEnabled = false
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        
        
    }
    

    @IBAction func SignInBtnClick(_ sender: Any) {
        
       if verifyUserInput()
       {
        
        }
       else{
        
        }
    }
    
    func verifyUserInput() ->Bool {
        
         let loginEmail = txtLoginEmail.text
         let passWord = txtLoginPassword.text
       return Q6JobServiceCommonLibrary.isEmailAddressValid(email: loginEmail!)&&(passWord!.isEmpty == false)
        
    }
    func registerForKeyboardNotifications()
    {
        
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //        //Adding notifies on keyboard appearing
        //        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWasShown:"), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(_ notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if activeField != nil
        {
            if (!aRect.contains(activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        
        
    }
    
    
    func keyboardWillBeHidden(_ notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeField = nil
    }

}

