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
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listSummary: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
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
    }

    @IBAction func onCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onDone(sender: AnyObject) {
        addPayment(amount(), type: type!)
    }
    
    private func addPayment(amount: Float, type: Type) {
        if (amount > 0) {
            let payment = Payment(amount: amount, type: type, label: "")
            Data.addPayment(payment)
            update()
            onClear("")
        }
    }
    
    private func update() {
        if Data.listCount() > 1 || (Data.listName().rangeOfString("tab", options: .RegularExpressionSearch) == nil) {
            listName.text = Data.listName()
        } else {
            listName.text = ""
        }

        let totalOwingsAmount: Float = Data.totalOwings()
        
        if (abs(totalOwingsAmount) < 0.01) {
            listSummary.text = "owes me nothing"
        } else {
            let prefix = totalOwingsAmount < 0 ? "is owed" : "owes me"
            listSummary.text = prefix + " " + Util.toMoney(abs(totalOwingsAmount))
        }
        
        doneButton.setTitle(FrontViewController.getButtonLabel(type!), forState: UIControlState.Normal)
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
        doneButton.titleLabel?.textAlignment = NSTextAlignment.Center
        update()
        onClear("")
    }
    
    override func viewWillAppear(animated: Bool) {
//        navigationController!.setNavigationBarHidden(true, animated: false)
      update()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        navigationController!.setNavigationBarHidden(false, animated: false)
    }
}

