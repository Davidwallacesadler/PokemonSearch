//
//  SpritesTableViewCell.swift
//  PokemonSearch
//
//  Created by David Sadler on 9/22/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class SpritesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backDefaultImageView: UIImageView!
    @IBOutlet weak var backFemaleImageView: UIImageView!
    @IBOutlet weak var backShinyImageView: UIImageView!
    @IBOutlet weak var backShinyFemaleImageView: UIImageView!
    @IBOutlet weak var frontDefaultImageView: UIImageView!
    @IBOutlet weak var frontFemaleImageView: UIImageView!
    @IBOutlet weak var frontShinyImageView: UIImageView!
    @IBOutlet weak var frontShinyFemale: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
