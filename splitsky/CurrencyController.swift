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
        tableView.register(UINib(nibName: "CurrencyHeaderCell", bundle: nil), forCellReuseIdentifier: "CurrencyHeaderCell")    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(false, animated: false)
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.clipsToBounds = true
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.currencyCount() + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        if row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "CurrencyHeaderCell", for: indexPath) as! CurrencyHeaderCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
            let currency = Data.currencies()[row - 1]
            let rate = Util.toMoney(amount: Data.getRate(currencyTla: currency.tla()), decPlc: 2)
            
            cell.nameLabel.text = currency.name()
            cell.rateLabel.text = "\(rate) \(currency.tla())"
            
            cell.separatorInset = UIEdgeInsets.zero
            cell.backgroundColor = UIColor.black
            cell.layoutIfNeeded()
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = (indexPath as NSIndexPath).row
        if row != 0 {
            let currency = Data.currencies()[row - 1]
            Data.setActiveCurrency(currency: currency)
            navigationController?.popViewController(animated: true)
        }
    }
}
