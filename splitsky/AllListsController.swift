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
        tableView.register(UINib(nibName: "AllListsCell", bundle: nil), forCellReuseIdentifier: "AllListsCell")
        tableView.register(UINib(nibName: "AddFriendCell", bundle: nil), forCellReuseIdentifier: "AddFriendCell")
        labelModal = Modal(viewName: "Label", owner: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(false, animated: false)
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.clipsToBounds = true
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        return notWorthMentioning() ? 1 : 1 + Data.listCount()
    }
    
    fileprivate func notWorthMentioning() -> Bool {
        return Data.theyOweMe() == 0 && Data.listCount() <= 1 && !Data.isNamed()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).row == 0 {
            return addFriendCell(tableView, indexPath: indexPath)
        } else {
            return addRowCell(tableView, indexPath: indexPath)
        }
    }
    
    fileprivate func addFriendCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllListsCell", for: indexPath) as! PaymentCell
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.black
        cell.labelCallback = {
            if self.notWorthMentioning() {
                let kill = Data.listName()
                Data.newList()
                Data.removeList(kill)
            } else {
                Data.newList()
            }
            tableView.reloadData()
        }
        cell.words.isHidden = true
        cell.delete.isHidden = true
        cell.label.setTitle("Add", for: UIControlState())
        return cell
    }
    
    fileprivate func addRowCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllListsCell", for: indexPath) as! PaymentCell
        cell.words.isHidden = false
        cell.delete.isHidden = false
        
        let allPayments = Data.allPayments()
        let names = allPayments.keys.sorted()
        let name = names[(indexPath as NSIndexPath).row - 1]
        let oldList = Data.listName()
        Data.setList(name)

        setWords(cell)
        
        Data.setList(oldList)
        cell.label.setTitle(name.capitalized, for: UIControlState())
        cell.label.titleLabel!.numberOfLines = 1
        cell.label.titleLabel!.adjustsFontSizeToFitWidth = true
        cell.label.titleLabel!.lineBreakMode = NSLineBreakMode.byClipping
        
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
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    fileprivate func setWords(_ cell: PaymentCell) {
        let totalOwingsAmount = Data.theyOweMe()
        
        if abs(totalOwingsAmount) < 0.01 {
            cell.words.text = "owes me nothing"
        } else {
            cell.words.text = totalOwingsAmount < 0 ? "is owed" : "owes me"
            cell.words.text = cell.words.text! + " " + Util.toMoney(amount: abs(totalOwingsAmount))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row != 0 {
            let allPayments = Data.allPayments()
            let names = allPayments.keys.sorted()
            let name = names.count >= (indexPath as NSIndexPath).row ? names[(indexPath as NSIndexPath).row - 1] : Data.defaultName()
            Data.setList(name)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 9
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let labelTextBox = self.labelModal?.findElementByTag(1) as! UITextField
        labelTextBox.resignFirstResponder()
        self.labelModal!.slideDownToBottom(self.view)
        if activeList != textField.text {
            Data.changeName(activeList!, newName: textField.text!)
            if Data.listName().uppercased() == activeList?.uppercased() {
                Data.setList(textField.text!)
            }
            tableView.reloadData()
        }
        return true
    }
}
