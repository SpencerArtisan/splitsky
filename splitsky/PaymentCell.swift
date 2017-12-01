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
    var wordsCallback: (() -> ())?

    
    @IBOutlet weak var words: UIButton!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var label: UIButton!
    @IBOutlet weak var breakdown: UILabel!
    
    @IBAction func onLabel(_ sender: AnyObject) {
       labelCallback!()
    }
    
    @IBAction func onDelete(_ sender: AnyObject) {
        deleteCallback!()
    }
    
    @IBAction func onWords(_ sender: Any) {
        wordsCallback!()
    }
}
