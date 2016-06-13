//
//  NextDay.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/9/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit

class NextDayCell: UITableViewCell {

    @IBOutlet weak var datesLbl: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var tempLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configureCell(day: Day) {
        
        datesLbl.text = day.date
        weatherImg.image = day.weatherImg
        tempLbl.text = day.temp
    }
    
}
