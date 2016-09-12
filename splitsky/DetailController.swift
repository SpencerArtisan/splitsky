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

        setWords(payment, cell: cell)

        cell.label.hidden = payment._type == Type.iBorrowed || payment._type == Type.theyBorrowed
        
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
        
        cell.layoutIfNeeded()
        cell.label.frame = CGRectMake(cell.label.frame.origin.x, cell.label.frame.origin.y, 60, cell.label.frame.height)
        cell.delete.frame = CGRectMake(cell.delete.frame.origin.x + 30, cell.delete.frame.origin.y, 60, cell.delete.frame.height)
        cell.words.frame = CGRectMake(cell.label.frame.maxX + 10, cell.words.frame.origin.y, 240, cell.words.frame.height)

        return cell
    }
    
    private func setWords(payment: Payment, cell: PaymentCell) {
        let they = "\(Data.listName().capitalizedString)"
        if payment._type == Type.theyPaid {
            cell.words.text = "\(they) paid bill of"
        } else if payment._type == Type.iPaid {
            cell.words.text = "I paid bill of"
        } else if payment._type == Type.theyBorrowed {
            cell.words.text = "I gave \(they)"
        } else if payment._type == Type.iBorrowed {
            cell.words.text = "\(they) gave me"
        }
        cell.words.text = cell.words.text! + " " + Util.toMoney(payment._amount) + SPACE
    }
}
