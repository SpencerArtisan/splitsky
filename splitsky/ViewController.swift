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
    var typeModal: Modal?
    var label: String = ""
    
    @IBOutlet weak var listSummary: UIButton!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var listName: UILabel!

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
        evenSplitButton.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        evenSplitButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        lobsterButton.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        lobsterButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
    }

    @IBAction func onCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onEvenSplit(sender: AnyObject) {
        addPayment(amount(), type: type!)
    }
    
    @IBAction func onLobsterSplit(sender: AnyObject) {
    }
    
    @IBAction func onLabel(sender: AnyObject) {
        UIView.animateWithDuration(0.1, animations: {
            self.view.subviews.forEach { $0.alpha = 0.7 }
        })
        self.typeModal!.slideUpFromBottom(self.view)

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
        labelButton.setTitle("", forState: UIControlState.Normal)
        let image = UIImage(named: name)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        labelButton.setImage(image, forState: UIControlState.Normal)
        labelButton.tintColor = UIColor.whiteColor()
        self.typeModal!.slideDownToBottom(self.view)
    }
    
    private func addPayment(amount: Float, type: Type) {
        if (amount > 0) {
            let payment = Payment(amount: amount, type: type, label: label)
            Data.addPayment(payment)
            update()
            onClear("")
            labelButton.setTitle("Label", forState: UIControlState.Normal)
            labelButton.setImage(nil, forState: UIControlState.Normal)
        }
    }
    
    private func update() {
        listName.text = Data.listName().capitalizedString
        let totalOwingsAmount: Float = Data.totalOwings()
        
        if (abs(totalOwingsAmount) < 0.01) {
            listSummary.setTitle("owes me nothing", forState: UIControlState.Normal)
        } else {
            let prefix = totalOwingsAmount < 0 ? "is owed" : "owes me"
            listSummary.setTitle(prefix + " " + Util.toMoney(abs(totalOwingsAmount)), forState: UIControlState.Normal)
        }
        
        navigation.title = FrontViewController.getButtonLabel(type!).stringByReplacingOccurrencesOfString("\n", withString: " ")
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
        evenSplitButton.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        evenSplitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        lobsterButton.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        lobsterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
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
        evenSplitButton.titleLabel?.textAlignment = NSTextAlignment.Center
        lobsterButton.titleLabel?.textAlignment = NSTextAlignment.Center
        update()
        onClear("")
        typeModal = Modal(viewName: "PaymentType", owner: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        update()
    }
    
    override func viewDidLayoutSubviews() {
        if (type == Type.iBorrowed || type == Type.theyBorrowed) {
            evenSplitButton.frame = CGRectMake(0, evenSplitButton.frame.origin.y, view.frame.width, evenSplitButton.frame.height)
            labelButton.removeFromSuperview()
            lobsterButton.removeFromSuperview()
            evenSplitButton.setTitle("Done", forState: UIControlState.Normal)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        navigationController!.setNavigationBarHidden(false, animated: false)
    }
}

