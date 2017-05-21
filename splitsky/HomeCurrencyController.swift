//
//  HomeCurrencyController.swift
//  Splitsky
//
//  Created by Spencer Ward on 21/05/2017.
//  Copyright © 2017 Spencer Ward. All rights reserved.
//

import UIKit

class HomeCurrencyController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HomeCurrencyCell", bundle: nil), forCellReuseIdentifier: "HomeCurrencyCell")
        tableView.register(UINib(nibName: "HomeCurrencyHeaderCell", bundle: nil), forCellReuseIdentifier: "HomeCurrencyHeaderCell")    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(false, animated: false)
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.clipsToBounds = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.currencyCount() + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        if row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "HomeCurrencyHeaderCell", for: indexPath) as! HomeCurrencyHeaderCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCurrencyCell", for: indexPath) as! HomeCurrencyCell
            let currency = Data.currencies()[row - 1]
            
            cell.currency.text = currency.name()
            
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
            Data.setHomeCurrency(currency: currency)
            Data.setActiveCurrency(currency: currency)
            RestClient.getRates(onCompletion: {_ in
                DispatchQueue.main.async {
                    Data.set(PaymentRepository.load())
                    self.navigationController?.popViewController(animated: true)
                }})
        }
    }
}
