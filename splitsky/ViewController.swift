//
//  ViewController.swift
//  owings
//
//  Created by Spencer Ward on 19/06/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var type: Type?
    private var typeModal: Modal?
    private var label: String = ""
    private var splitPayment: Payment?
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listSummary: UIButton!
    @IBOutlet weak var evenSplitButton: UIButton!
    @IBOutlet weak var lobsterButton: UIButton!
    @IBOutlet weak var labelButton: UIButton!

    let SPACE = " \u{200c}"

    @IBAction func onDot(sender: AnyObject) {
        if !number.text!.containsString(".") {
            addText(".")
        }
    }
    
    @IBAction func on0(sender: AnyObject) {
        onDigit("0")
    }
    
    @IBAction func on1(sender: AnyObject) {
        onDigit("1")
    }
    
    @IBAction func on2(sender: AnyObject) {
        onDigit("2")
    }
    
    @IBAction func on3(sender: AnyObject) {
        onDigit("3")
    }
    
    @IBAction func on4(sender: AnyObject) {
        onDigit("4")
    }
    
    @IBAction func on5(sender: AnyObject) {
        onDigit("5")
    }
    
    @IBAction func on6(sender: AnyObject) {
        onDigit("6")
    }
    
    @IBAction func on7(sender: AnyObject) {
        onDigit("7")
    }

    @IBAction func on8(sender: AnyObject) {
        onDigit("8")
    }
    
    @IBAction func on9(sender: AnyObject) {
        onDigit("9")
    }
    
    @IBAction func onClear(sender: AnyObject) {
        number.text = "0" + SPACE
        Util.disable(evenSplitButton)
        Util.disable(lobsterButton)
    }

    @IBAction func onCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // Or the My Lobster button in lobster mode
    @IBAction func onEvenSplit(sender: AnyObject) {
        if splitPayment != nil {
            splitPayment!.allocateToMe(amount())
            updateLobsterMode()
        } else if amount() > 0 {
            addPayment(Payment(amount: amount(), type: type!, label: label))
        }
        onClear("")
    }
    
    // Or the Their Lobster button in lobster mode
    @IBAction func onLobsterSplit(sender: AnyObject) {
        if splitPayment != nil {
            splitPayment!.allocateToThem(amount())
        } else {
            Util.enable(labelButton)
            Util.setText(labelButton, text: "Split\nRemainder\n50/50")
            Util.setText(evenSplitButton, text: "My\nLobster")
            Util.setText(lobsterButton, text: "\(Data.listName().capitalizedString)\nLobster")
            listName.text = "Uneven Split Bill"
            listSummary.enabled = false
            splitPayment = Payment.init(amount: amount(), type: type!, label: label)
        }
        updateLobsterMode()
        onClear("")
    }
    
    private func updateLobsterMode() {
        Util.setText(listSummary, text: "Remainder \(splitPayment!.evenlySplit())")
    }
    
    // Or the Split Remainder button in lobster mode
    @IBAction func onLabel(sender: AnyObject) {
        if splitPayment != nil {
            addPayment(splitPayment!)
        } else {
            UIView.animateWithDuration(0.1, animations: {
                self.view.subviews.forEach { $0.alpha = 0.7 }
            })
            self.typeModal!.slideUpFromBottom(self.view)
        }
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
        UIView.animateWithDuration(0.1, animations: {
            self.view.subviews.forEach { $0.alpha = 1 }
        })
        label = name
        Util.setImage(labelButton!, image: UIImage(named: name)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        labelButton.tintColor = UIColor.whiteColor()
        self.typeModal!.slideDownToBottom(self.view)
    }
    
    private func addPayment(payment: Payment) {
        Data.addPayment(payment)
        update()
        onClear("")
        Util.setText(labelButton!, text: "Label")
    }
    
    private func update() {
        listName.text = Data.listName().capitalizedString
        let totalOwingsAmount: Float = Data.theyOweMe()
        if abs(totalOwingsAmount) < 0.01 {
            listSummary.setTitle("owes me nothing", forState: UIControlState.Normal)
        } else {
            let prefix = totalOwingsAmount > 0 ? "owes me" : "is owed"
            Util.setText(listSummary, text: prefix + " " + Util.toMoney(abs(totalOwingsAmount)))
        }
        
        navigation.title = FrontViewController.getButtonLabel(type!).stringByReplacingOccurrencesOfString("\n", withString: " ")
        listSummary.enabled = true
        label = ""
        splitPayment = nil
        Util.setText(lobsterButton!, text: "Uneven\nSplit")
        Util.setText(evenSplitButton!, text: "50/50\nSplit")
        Util.setText(labelButton!, text: "Label")
    }
    
    private func amount() -> Float {
        return Float(numberText())!
    }
    
    private func onDigit(digit: String) {
        if number.text! == "0" + SPACE {
            number.text = ""
        }
        if number.text!.stringByReplacingOccurrencesOfString(".", withString: "").characters.count < 7 && noMoreThan2DecimalPlaces() {
            addText(digit)
        }
        if splitPayment == nil || amount() <= splitPayment!.evenlySplit() {
            Util.enable(evenSplitButton)
            Util.enable(lobsterButton)
        } else {
            Util.disable(evenSplitButton)
            Util.disable(lobsterButton)
        }
    }
    
    private func noMoreThan2DecimalPlaces() -> Bool {
        return !numberText().containsString(".") || (numberText() as NSString).substringFromIndex(numberText().characters.count - 2).containsString(("."))
    }

    private func addText(char: String) {
        number.text = numberText() + char + SPACE
    }
    
    private func numberText() -> String {
        return number.text!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: SPACE))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Util.center(evenSplitButton)
        Util.center(lobsterButton)
        Util.center(labelButton)
        update()
        onClear("")
        typeModal = Modal(viewName: "PaymentType", owner: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        update()
        navigationController!.setNavigationBarHidden(false, animated: false)
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        navigationController!.navigationBar.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        if type == Type.iBorrowed || type == Type.theyBorrowed {
            evenSplitButton.frame = CGRectMake(0, evenSplitButton.frame.origin.y, view.frame.width, evenSplitButton.frame.height)
            labelButton.removeFromSuperview()
            lobsterButton.removeFromSuperview()
            evenSplitButton.setTitle("Done", forState: UIControlState.Normal)
        }
    }
}

