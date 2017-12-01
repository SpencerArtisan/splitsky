//
//  PaymentCell.swift
//  Splitsky
//
//  Created by Spencer Ward on 10/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    var deleteCallback: (() -> ())?
    var labelCallback: (() -> ())?

    @IBOutlet weak var words: UILabel!
    
    @IBAction func onLabel(_ sender: Any) {
        labelCallback?()
    }
    
    @IBOutlet weak var breakdown: UILabel!
    @IBOutlet weak var label: UIButton!
    
    @IBAction func onDelete(_ sender: Any) {
        deleteCallback?()
    }
    
    @IBOutlet weak var delete: UIButton!
}
