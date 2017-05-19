//
//  DetailController.swift
//  Splitsky
//
//  Created by Spencer Ward on 10/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import UIKit

class CurrencyController: UITableViewController {
    let SPACE = "  \u{200c}"

    var activePayment: Payment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(false, animated: false)
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.clipsToBounds = true
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.currencyCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        
        let currency = Data.currencies()[(indexPath as NSIndexPath).row]

        cell.tlaLabel.text = currency.tla()
        cell.nameLabel.text = currency.name()
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.black
        cell.layoutIfNeeded()
        
        return cell
    }
}
