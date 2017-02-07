//
//  MovieCell.swift
//  Flicks
//
//  Created by Rajjwal Rawal on 1/31/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit
import Cosmos

class MovieCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var cosmosView: CosmosView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
