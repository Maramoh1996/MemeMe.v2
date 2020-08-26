//
//  MemeTableViewCell.swift
//  MemeMe.1.0
//
//  Created by Maram Moh on 19/06/2020.
//  Copyright © 2020 Maram Moh. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var imageTable: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
