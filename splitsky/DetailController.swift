//
//  DetailController.swift
//  Splitsky
//
//  Created by Spencer Ward on 10/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import UIKit

class DetailController: UITableViewController {
    let SPACE = "  \u{200c}"
    var theySettledColor: UIColor = UIColor.blackColor()
    var iSettledColor: UIColor = UIColor.blackColor()
    var theyPaidColor: UIColor = UIColor.blackColor()
    var iPaidColor: UIColor = UIColor.blackColor()
    var labelColor: UIColor?
    var typeModal: Modal?
    
    var activePayment: Payment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "PaymentCell")
        tableView.registerNib(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        typeModal = Modal(viewName: "PaymentType", owner: self)
    }
    
    @IBAction func onFood(sender: AnyObject) {
        addLabel("Food")
    }
    
    @IBAction func onDrink(sender: AnyObject) {
        addLabel("Drink")
    }

    @IBAction func onAccommodation(sender: AnyObject) {
        addLabel("Accommodation")
    }
    
    @IBAction func onTickets(sender: AnyObject) {
        addLabel("Tickets")
    }
    
    @IBAction func onTravel(sender: AnyObject) {
        addLabel("Travel")
    }
    
    @IBAction func onGroceries(sender: AnyObject) {
        addLabel("Groceries")
    }
    
    private func addLabel(name: String) {
        activePayment!._label = name
        PaymentRepository.save(Data.payments())
        tableView.reloadData()
        self.typeModal!.slideDownToBottom(self.view)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.paymentCount() + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath)
            cell.separatorInset = UIEdgeInsetsZero
            cell.backgroundColor = UIColor.blackColor()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("PaymentCell", forIndexPath: indexPath) as! PaymentCell
            let payment = Data.payments()[indexPath.row - 1]
            
            if labelColor == nil {
                labelColor = cell.label.backgroundColor
            }
            
            cell.deleteCallback = {
                Data.removePayment(indexPath.row - 1)
                tableView.reloadData()
            }
            
            cell.labelCallback = {
                self.activePayment = payment
                self.typeModal!.slideUpFromBottom(self.view)
            }
            
            if payment._type == Type.theyPaid || payment._type == Type.theySettled {
                cell.iOweThem.text = toMoney(payment._amount) + SPACE
                cell.iOweThem.backgroundColor = payment._type == Type.theySettled ? theySettledColor : theyPaidColor
                //cell.label.hidden = payment._type == Type.theySettled
                cell.amount.backgroundColor = UIColor.blackColor()
                cell.amount.text = ""
            } else {
                cell.amount.text = toMoney(payment._amount) + SPACE
                cell.amount.backgroundColor = payment._type == Type.iSettled ? iSettledColor : iPaidColor
                //cell.label.hidden = payment._type == Type.iSettled
                cell.iOweThem.backgroundColor = UIColor.blackColor()
                cell.iOweThem.text = ""
            }
            
            if payment._type == Type.iSettled {
                cell.label.setTitle("", forState: UIControlState.Normal)
                cell.label.setImage(UIImage(named: "MoneyRight"), forState: UIControlState.Normal)
                cell.label.backgroundColor = UIColor.blackColor()
            } else if payment._type == Type.theySettled {
                cell.label.setTitle("", forState: UIControlState.Normal)
                cell.label.setImage(UIImage(named: "MoneyLeft"), forState: UIControlState.Normal)
                cell.label.backgroundColor = UIColor.blackColor()
            } else if payment._label != "" {
                cell.label.setTitle("", forState: UIControlState.Normal)
                cell.label.setImage(UIImage(named: payment._label + "Small"), forState: UIControlState.Normal)
                cell.label.backgroundColor = UIColor.blackColor()
            } else if labelColor != nil {
                cell.label.setTitle("Label", forState: UIControlState.Normal)
                cell.label.backgroundColor = labelColor!
            }
            cell.separatorInset = UIEdgeInsetsZero
            cell.backgroundColor = UIColor.blackColor()
            
            return cell
        }
    }
    
    private func toMoney(amount: Float) -> String  {
        return (NSString(format: "%.2f", amount) as String)
    }
}
