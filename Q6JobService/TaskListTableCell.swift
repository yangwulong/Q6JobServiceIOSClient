//
//  TaskListTableCell.swift
//  Q6JobService
//
//  Created by yang wulong on 15/5/17.
//  Copyright © 2017 q6. All rights reserved.
//

import UIKit

class TaskListTableCell: UITableViewCell {

    @IBOutlet weak var JobReferenceNO: UILabel!
    @IBOutlet weak var StaffName: UILabel!
    
    @IBOutlet weak var DueDate: UILabel!
    
    @IBOutlet weak var DueDateLabel: UILabel!
    
    @IBOutlet weak var TaskDetail: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
