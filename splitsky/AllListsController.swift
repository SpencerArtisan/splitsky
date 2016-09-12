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
        tableView.registerNib(UINib(nibName: "AddFriendCell", bundle: nil), forCellReuseIdentifier: "AddFriendCell")
        labelModal = Modal(viewName: "Label", owner: self)
    }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notWorthMentioning() ? 1 : 1 + Data.listCount()
    }
    
    private func notWorthMentioning() -> Bool {
        return Data.totalOwings() == 0 && Data.listCount() <= 1 && !Data.isNamed()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            return addFriendCell(tableView, indexPath: indexPath)
        } else {
            return addRowCell(tableView, indexPath: indexPath)
        }
    }
    
    private func addFriendCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddFriendCell", forIndexPath: indexPath) as! AddFriendCell
        cell.separatorInset = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.blackColor()
        cell.addCallback = {
            if self.notWorthMentioning() {
                let kill = Data.listName()
                Data.newList()
                Data.removeList(kill)
            } else {
                Data.newList()
            }
            tableView.reloadData()
        }
        return cell
    }
    
    private func addRowCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PaymentCell", forIndexPath: indexPath) as! PaymentCell
        let allPayments = Data.allPayments()
        let names = allPayments.keys.sort()
        let name = names[indexPath.row - 1]
        let oldList = Data.listName()
        Data.setList(name)

        setWords(cell)
        
        Data.setList(oldList)
        cell.label.setTitle(name.capitalizedString, forState: UIControlState.Normal)
        cell.label.titleLabel!.numberOfLines = 1
        cell.label.titleLabel!.adjustsFontSizeToFitWidth = true
        cell.label.titleLabel!.lineBreakMode = NSLineBreakMode.ByClipping
        
        cell.deleteCallback = {
            Data.removeList(name)
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
    
    private func setWords(cell: PaymentCell) {
        let totalOwingsAmount = Data.totalOwings()
        
        if (abs(totalOwingsAmount) < 0.01) {
            cell.words.text = "owes me nothing"
        } else {
            cell.words.text = totalOwingsAmount < 0 ? "is owed" : "owes me"
            cell.words.text = cell.words.text! + " " + Util.toMoney(abs(totalOwingsAmount))
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let allPayments = Data.allPayments()
        let names = allPayments.keys.sort()
        let name = names.count > indexPath.row ? names[indexPath.row - 1] : Data.defaultName()
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
            if Data.listName().uppercaseString == activeList?.uppercaseString {
                Data.setList(textField.text!)
            }
            tableView.reloadData()
        }
        return true
    }
}
