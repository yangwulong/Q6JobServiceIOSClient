//
//  JobListTableViewCell.swift
//  Q6JobService
//
//  Created by yang wulong on 19/5/17.
//  Copyright © 2017 q6. All rights reserved.
//

import UIKit

class JobListTableViewCell: UITableViewCell {

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
