//
//  TaskSearchBar.swift
//  Q6JobService
//
//  Created by yang wulong on 11/5/17.
//  Copyright © 2017 q6. All rights reserved.
//

import UIKit

class TaskSearchBar: UISearchBar {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpView()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUpView(){
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.1;
        self.layer.borderColor = UIColor.black.cgColor
        
    }
    
}
