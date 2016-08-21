//
//  PaymentCell.swift
//  Splitsky
//
//  Created by Spencer Ward on 10/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {
    var deleteCallback: (() -> ())?
    var labelCallback: (() -> ())?

    @IBOutlet weak var words: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var label: UIButton!
    
    @IBAction func onLabel(sender: AnyObject) {
        labelCallback!()
    }
    
    @IBAction func onDelete(sender: AnyObject) {
        deleteCallback!()
    }
}
