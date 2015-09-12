//
//  DailyWeatherTableViewCell.swift
//  Stormy
//
//  Created by Poh Kah Kong on 12/9/15.
//  Copyright (c) 2015 Algomized. All rights reserved.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var dayLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
