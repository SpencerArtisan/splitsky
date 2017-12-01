//
//  AllListsCell.swift
//  Splitsky
//
//  Created by Spencer Ward on 01/12/2017.
//  Copyright © 2017 Spencer Ward. All rights reserved.
//

import UIKit

class AllListsCell: UITableViewCell {

    var deleteCallback: (() -> ())?
    var labelCallback: (() -> ())?
    var wordsCallback: (() -> ())?
    
    @IBAction func onDelete(_ sender: Any) {
        deleteCallback!()
    }
    @IBAction func onWords(_ sender: Any) {
        wordsCallback!()
    }
    @IBAction func onLabel(_ sender: Any) {
        labelCallback!()
    }
    
    @IBOutlet weak var label: UIButton!
    @IBOutlet weak var words: UIButton!
    @IBOutlet weak var delete: UIButton!
}
