//
//  MapsTableViewCell.swift
//  TesteMobile
//
//  Created by Jaber Shamali on 17/02/19.
//  Copyright © 2019 Jaber Shamali. All rights reserved.
//

import UIKit

class MapsTableViewCell: UITableViewCell {

    var url: String!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var descripLb: UILabel!



    @IBAction func callUrl(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: url.replacingOccurrences(of: " ", with: ""))!, options: [:], completionHandler: nil)
    }
    
}
