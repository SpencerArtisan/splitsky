//
//  AllListsController.swift
//  Splitsky
//
//  Created by Spencer Ward on 21/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import UIKit

class AllListsController: UITableViewController, UITextFieldDelegate {
    var activeList: String?
    var labelModal: Modal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "PaymentCell")
        labelModal = Modal(viewName: "Label", owner: self)
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
        let totalOwingsAmount = Data.totalOwings()
        
        if (abs(totalOwingsAmount) < 0.01) {
            cell.words.text = "We're Even!"
            cell.amount.text = ""
        } else {
            cell.words.text = totalOwingsAmount < 0 ? "I Owe Them" : "They Owe Me"
            cell.amount.text = Util.toMoney(abs(totalOwingsAmount))
        }

        Data.setList(oldList)
        cell.label.setTitle(name, forState: UIControlState.Normal)
        cell.label.titleLabel!.numberOfLines = 1
        cell.label.titleLabel!.adjustsFontSizeToFitWidth = true
        cell.label.titleLabel!.lineBreakMode = NSLineBreakMode.ByClipping
        
        cell.delete.hidden = Data.listCount() == 1
        
        cell.deleteCallback = {
            Data.removeList(name)
            if Data.listName() == name {
                Data.setList(names[0])
            }
            tableView.reloadData()
        }
        
        cell.labelCallback = {
            self.activeList = name
            self.labelModal!.slideUpFromBottom(self.view)
            let labelTextBox = self.labelModal?.findElementByTag(1) as! UITextField
            labelTextBox.enablesReturnKeyAutomatically = true
            labelTextBox.text = name
            labelTextBox.becomeFirstResponder()
            labelTextBox.delegate = self
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 10
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let labelTextBox = self.labelModal?.findElementByTag(1) as! UITextField
        labelTextBox.resignFirstResponder()
        self.labelModal!.slideDownToBottom(self.view)
        if activeList != textField.text {
            Data.changeName(activeList!, newName: textField.text!)
            if Data.listName() == activeList {
                Data.setList(textField.text!)
            }
            tableView.reloadData()
        }
        return true
    }
}
