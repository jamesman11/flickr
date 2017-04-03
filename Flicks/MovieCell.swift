//
//  MovieCell.swift
//  Flicks
//
//  Created by James Man on 3/31/17.
//  Copyright © 2017 James Man. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet var posterView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
