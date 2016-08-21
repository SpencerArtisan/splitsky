//
//  ViewController.swift
//  owings
//
//  Created by Spencer Ward on 19/06/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var youPaidTotal: UILabel!
    @IBOutlet weak var theyPaidTotal: UILabel!
    
    @IBOutlet weak var iSettledTotal: UILabel!
    @IBOutlet weak var theySettledTotal: UILabel!
    
    @IBOutlet weak var totalOwings: UILabel!
    @IBOutlet weak var iPaidButton: UIButton!
    @IBOutlet weak var theyPaidButton: UIButton!
    @IBOutlet weak var iSettledButton: UIButton!
    @IBOutlet weak var theySettledButton: UIButton!
    
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
    
    @IBAction func onIPaid(sender: AnyObject) {
        addPayment(amount(), type: Type.iPaid)
    }

    @IBAction func onTheyPaid(sender: AnyObject) {
        addPayment(amount(), type: Type.theyPaid)
    }
    
    @IBAction func onISettleUp(sender: AnyObject) {
        addPayment(amount(), type: Type.iSettled)
    }

    @IBAction func onTheySettleUp(sender: AnyObject) {
        addPayment(amount(), type: Type.theySettled)
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
        youPaidTotal.text = toMoney(Data.iPaidTotal())
        theyPaidTotal.text = toMoney(Data.theyPaidTotal())
        iSettledTotal.text = toMoney(Data.iSettledTotal())
        theySettledTotal.text = toMoney(Data.theySettledTotal())
        
        let totalOwingsAmount: Float = Data.totalOwings()
        
        if (abs(totalOwingsAmount) < 0.01) {
            totalOwings.text = "We're Even!"
            totalOwings.backgroundColor = UIColor.blackColor()
        } else {
            let prefix = totalOwingsAmount < 0 ? "I Owe Them" : "They Owe Me"
            totalOwings.backgroundColor = totalOwingsAmount < 0 ? iSettledButton.backgroundColor : theySettledButton.backgroundColor
            totalOwings.text = prefix + " " + toMoney(abs(totalOwingsAmount))
        }
    }
    
    private func amount() -> Float {
        return Float(numberText())!
    }
    
    private func toMoney(amount: Float) -> String  {
        return (NSString(format: "%.2f", amount) as String)
    }
    
    private func onDigit(digit: String) {
        if number.text! == "0" + SPACE {
            number.text = ""
        }
        if number.text!.characters.count < 8 && noMoreThan2DecimalPlaces() {
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
        Data.set(PaymentRepository.load())
        update()
        onClear("")
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.setNavigationBarHidden(true, animated: false)
        update()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let vc = segue.destinationViewController as! DetailController
        vc.theySettledColor = theySettledButton.backgroundColor!
        vc.iSettledColor = iSettledButton.backgroundColor!
        vc.theyPaidColor = theyPaidButton.backgroundColor!
        vc.iPaidColor = iPaidButton.backgroundColor!
        
        navigationController!.setNavigationBarHidden(false, animated: false)
    }
}

