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
        PaymentRepository.save(Data.allPayments())
        tableView.reloadData()
        self.typeModal!.slideDownToBottom(self.view)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.paymentCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PaymentCell", forIndexPath: indexPath) as! PaymentCell
        let payment = Data.payments()[indexPath.row]
        
        if labelColor == nil {
            labelColor = cell.label.backgroundColor
        }
        
        cell.deleteCallback = {
            Data.removePayment(indexPath.row)
            tableView.reloadData()
        }
        
        cell.labelCallback = {
            self.activePayment = payment
            self.typeModal!.slideUpFromBottom(self.view)
        }
        
        if payment._type == Type.theyPaid {
            cell.words.text = "They paid"
        } else if payment._type == Type.iPaid {
            cell.words.text = "I paid"
        } else if payment._type == Type.iSettled {
            cell.words.text = "I settled"
        } else if payment._type == Type.theySettled {
            cell.words.text = "They settled"
        }
        cell.amount.text = toMoney(payment._amount) + SPACE
        cell.label.hidden = payment._type == Type.theySettled || payment._type == Type.iSettled
        
        if payment._label != "" {
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
    
    private func toMoney(amount: Float) -> String  {
        return (NSString(format: "%.2f", amount) as String)
    }
}
