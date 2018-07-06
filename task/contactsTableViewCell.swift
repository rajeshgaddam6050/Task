//
//  contactsTableViewCell.swift
//  task
//
//  Created by Rajesh on 03/07/18.
//  Copyright © 2018 Rajesh. All rights reserved.
//

import UIKit

class contactsTableViewCell: UITableViewCell {
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
