//
//  TaskListNavItem.swift
//  Q6JobService
//
//  Created by yang wulong on 17/5/17.
//  Copyright © 2017 q6. All rights reserved.
//

import UIKit

class TaskListNavItem: UINavigationItem {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpView()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUpView(){
//        let attrs = [
//            NSForegroundColorAttributeName: UIColor.red,
//            NSFontAttributeName: UIFont(name: "Georgia-Bold", size: 24)!
//        ]
//        
//        
//        UINavigationBar.appearance().titleTextAttributes = attrs
   }
    
}
