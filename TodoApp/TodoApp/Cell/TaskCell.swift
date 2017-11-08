//
//  TaskCell.swift
//  TodoApp
//
//  Created by Best Peers on 07/11/17.
//  Copyright © 2017 Best Peers. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var priorityButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }

}
