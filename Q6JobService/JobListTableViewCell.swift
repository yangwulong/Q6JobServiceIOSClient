//
//  JobListTableViewCell.swift
//  Q6JobService
//
//  Created by yang wulong on 19/5/17.
//  Copyright © 2017 q6. All rights reserved.
//

import UIKit

class JobListTableViewCell: UITableViewCell {

    @IBOutlet weak var AddressLine2: UILabel!
    @IBOutlet weak var AddressLine1: UILabel!
    @IBOutlet weak var ClientName: UILabel!
    @IBOutlet weak var DriveMinWithDrivekilo: UILabel!
    @IBOutlet weak var JobContactMobile: UILabel!
    @IBOutlet weak var LocalScheduleTime: UILabel!
    @IBOutlet weak var JobCategoryColor: UILabel!
    @IBOutlet weak var JobTypeColorLabel: UILabel!
    @IBOutlet weak var CustomerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
