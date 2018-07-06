//
//  CountryTableViewCell.swift
//  task
//
//  Created by Adaptiz on 05/07/18.
//  Copyright © 2018 KoniReddy. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var plusImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
