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
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell")
        typeModal = Modal(viewName: "PaymentType", owner: self)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 30
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(false, animated: false)
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.clipsToBounds = true
    }
    
    @IBAction func onFood(_ sender: AnyObject) {
        addLabel("Food")
    }
    
    @IBAction func onDrink(_ sender: AnyObject) {
        addLabel("Drink")
    }

    @IBAction func onAccommodation(_ sender: AnyObject) {
        addLabel("Accommodation")
    }
    
    @IBAction func onTickets(_ sender: AnyObject) {
        addLabel("Tickets")
    }
    
    @IBAction func onTravel(_ sender: AnyObject) {
        addLabel("Travel")
    }
    
    @IBAction func onGroceries(_ sender: AnyObject) {
        addLabel("Groceries")
    }
    
    fileprivate func addLabel(_ name: String) {
        activePayment!.setLabel(name)
        PaymentRepository.save(Data.allPayments())
        tableView.reloadData()
        self.typeModal!.slideDownToBottom(self.view)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.paymentCount() + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = (indexPath as NSIndexPath).row
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.label.text = Data.listName().capitalized + " " + Data.owingsSummary()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! PaymentCell
            let payment = Data.payments()[row - 1]
            
            if labelColor == nil {
                labelColor = cell.label.backgroundColor
            }
            
            cell.deleteCallback = {
                Data.removePayment(row - 1)
                tableView.reloadData()
            }
            
            cell.labelCallback = {
                self.activePayment = payment
                self.typeModal!.slideUpFromBottom(self.view)
            }
            
            cell.label.isHidden = payment.type() == Type.iBorrowed || payment.type() == Type.theyBorrowed
            
            if payment.hasLabel() {
                Util.setImage(cell.label, image: UIImage(named: payment.label() + "Small")!)
                cell.label.backgroundColor = UIColor.black
            } else if labelColor != nil {
                Util.setImage(cell.label, image: UIImage(named: "Question")!)
                cell.label.backgroundColor = UIColor.black
            }
            cell.separatorInset = UIEdgeInsets.zero
            cell.backgroundColor = UIColor.black
            
            setWords(payment, cell: cell)
            
            cell.layoutIfNeeded()
            if cell.breakdown.text == "" {
                cell.words.frame = CGRect(x: cell.words.frame.origin.x, y: 0, width: cell.words.frame.width, height: cell.frame.height)
            }
            
            return cell
        }
    }
    
    private func setWords(_ payment: Payment, cell: PaymentCell) {
        let they = "\(Data.listName().capitalized)"
        if payment.type() == Type.theyPaid {
            cell.words.text = "\(they) paid bill of"
        } else if payment.type() == Type.iPaid {
            cell.words.text = "I paid bill of"
        } else if payment.type() == Type.theyBorrowed {
            cell.words.text = "I gave \(they)"
        } else if payment.type() == Type.iBorrowed {
            cell.words.text = "\(they) gave me"
        }
        let currency = Data.getCurrency(tla: payment.currency())
        let gbpText = payment.currency() == "GBP" ? "" : "(\(Data.getCurrency(tla: "GBP").format(amount: payment.amount() / payment.rate())))"
        cell.words.text = "\(cell.words.text!) \(currency.format(amount: payment.amount())) \(gbpText)"
        
         cell.breakdown.text = ""
        if payment.isUneven() {
            if payment.myAllocations() > 0 {
                cell.breakdown.text = cell.breakdown.text! + "\(Util.toMoney(amount: payment.myAllocations(), decPlc: 0)) me, "
            }
            if payment.theirAllocations() > 0 {
                cell.breakdown.text = cell.breakdown.text! + "\(Util.toMoney(amount: payment.theirAllocations(), decPlc: 0)) \(they), "
            }
            if payment.myAllocations() > 0 || payment.theirAllocations() > 0 {
                cell.breakdown.text = cell.breakdown.text! + "rest even"
            }
        }
    }
}
