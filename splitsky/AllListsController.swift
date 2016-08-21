//
//  AllListsController.swift
//  Splitsky
//
//  Created by Spencer Ward on 21/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import UIKit

class AllListsController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "PaymentCell")
    }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.listCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PaymentCell", forIndexPath: indexPath) as! PaymentCell
        let allPayments = Data.allPayments()
        let names = allPayments.keys.sort()
        let name = names[indexPath.row]
        let oldList = Data.listName()
        Data.setList(name)
        cell.words.text = "They owe me"
        cell.amount.text = toMoney(abs(Data.totalOwings()))
        Data.setList(oldList)
        cell.label.setTitle(name, forState: UIControlState.Normal)
        cell.delete.hidden = Data.listCount() == 1
        
        cell.deleteCallback = {
            Data.removeList(name)
            tableView.reloadData()
        }
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.blackColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let allPayments = Data.allPayments()
        let names = allPayments.keys.sort()
        let name = names[indexPath.row]
        Data.setList(name)
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func toMoney(amount: Float) -> String  {
        return (NSString(format: "%.2f", amount) as String)
    }
}
