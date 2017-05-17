//
//  TaskListNaviationBar.swift
//  Q6JobService
//
//  Created by yang wulong on 17/5/17.
//  Copyright © 2017 q6. All rights reserved.
//

import UIKit

class TaskListNaviationBar: UINavigationBar {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpView()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUpView(){
                let attrs = [
                    NSForegroundColorAttributeName: UIColor.darkGray//,
                    //NSFontAttributeName: UIFont(name: "Georgia-Bold", size: 24)!
                ]
       
      
               // self.titleTextAttributes = attrs
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
}
