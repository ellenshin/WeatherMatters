//
//  CityCell.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/12/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var cityStateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(city: City) {
        cityStateLbl.text = "\(city.city.capitalizedString), \(city.state.capitalizedString)"
    }
    
}
