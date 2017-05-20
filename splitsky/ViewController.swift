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
    fileprivate var typeModal: Modal?
    fileprivate var label: String = ""
    fileprivate var splitPayment: Payment?
    var helpModal: Modal?
    

    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listSummary: UIButton!
    @IBOutlet weak var evenSplitButton: UIButton!
    @IBOutlet weak var lobsterButton: UIButton!
    @IBOutlet weak var labelButton: UIButton!

    let SPACE = " \u{200c}"

    @IBAction func onDot(_ sender: AnyObject) {
        if !number.text!.contains(".") {
            addText(".")
        }
    }
    
    @IBAction func on0(_ sender: AnyObject) {
        onDigit("0")
    }
    
    @IBAction func on1(_ sender: AnyObject) {
        onDigit("1")
    }
    
    @IBAction func on2(_ sender: AnyObject) {
        onDigit("2")
    }
    
    @IBAction func on3(_ sender: AnyObject) {
        onDigit("3")
    }
    
    @IBAction func on4(_ sender: AnyObject) {
        onDigit("4")
    }
    
    @IBAction func on5(_ sender: AnyObject) {
        onDigit("5")
    }
    
    @IBAction func on6(_ sender: AnyObject) {
        onDigit("6")
    }
    
    @IBAction func on7(_ sender: AnyObject) {
        onDigit("7")
    }

    @IBAction func on8(_ sender: AnyObject) {
        onDigit("8")
    }
    
    @IBAction func on9(_ sender: AnyObject) {
        onDigit("9")
    }
    
    @IBAction func onClear(_ sender: AnyObject) {
        number.text = "0" + SPACE
        Util.disable(evenSplitButton)
        Util.disable(lobsterButton)
    }

    @IBAction func onCancel(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    // Or the My Lobster button in lobster mode
    @IBAction func onEvenSplit(_ sender: AnyObject) {
        if splitPayment != nil {
            splitPayment!.allocateToMe(amount())
            updateLobsterMode()
        } else if amount() > 0 {
            addPayment(Payment(amount: amount(), currency: Data.activeCurrency().tla(), rate: Data.activeRate(), type: type!, label: label))
        }
        onClear("" as AnyObject)
    }
    
    // Or the Their Lobster button in lobster mode
    @IBAction func onLobsterSplit(_ sender: AnyObject) {
        if splitPayment != nil {
            splitPayment!.allocateToThem(amount())
        } else {
            Util.enable(labelButton)
            Util.setText(labelButton, text: "Split\nRest\n50/50")
            Util.setText(evenSplitButton, text: "My\nLobster")
            Util.setText(lobsterButton, text: "\(Data.listName().capitalized)\nLobster")
            listName.text = "Uneven Split Bill"
            listSummary.isEnabled = false
            splitPayment = Payment.init(amount: amount(), currency: Data.activeCurrency().tla(), rate: Data.activeRate(), type: type!, label: label)
            if !Preferences.hadLobsterHelp() {
                helpModal?.slideDownFromTop(view)
                Preferences.hadLobsterHelp(value: true)
            }
        }
        updateLobsterMode()
        onClear("" as AnyObject)
    }
    
    fileprivate func updateLobsterMode() {
        Util.setText(listSummary, text: "Remainder \(splitPayment!.evenlySplit())")
    }
    
    // Or the Split Remainder button in lobster mode
    @IBAction func onLabel(_ sender: AnyObject) {
        if splitPayment != nil {
            addPayment(splitPayment!)
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.view.subviews.forEach { $0.alpha = 0.7 }
            })
            self.typeModal!.slideUpFromBottom(self.view)
        }
    }
    
    @IBAction func onClickHelp(_ sender: Any) {
        helpModal?.slideUpFromTop(self.view)
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
        UIView.animate(withDuration: 0.1, animations: {
            self.view.subviews.forEach { $0.alpha = 1 }
        })
        label = name
        Util.setImage(labelButton!, image: UIImage(named: name)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        labelButton.tintColor = UIColor.white
        self.typeModal!.slideDownToBottom(self.view)
    }
    
    fileprivate func addPayment(_ payment: Payment) {
        Data.addPayment(payment)
        update()
        onClear("" as AnyObject)
        Util.setText(labelButton!, text: "Label")
        Util.orange(labelButton!)
    }
    
    fileprivate func update() {
        listName.text = Data.listName().capitalized
        Util.setText(listSummary, text: Data.owingsSummary())
        
        navigation.title = FrontViewController.getButtonLabel(type!).replacingOccurrences(of: "\n", with: " ")
        listSummary.isEnabled = true
        listSummary.titleLabel?.minimumScaleFactor = 0.5
        listSummary.titleLabel?.adjustsFontSizeToFitWidth = true
        label = ""
        splitPayment = nil
        Util.setText(lobsterButton!, text: "Uneven\nSplit")
        Util.setText(evenSplitButton!, text: "50/50\nSplit")
        Util.setText(labelButton!, text: "Label")
        Util.setText(currencyButton!, text: Data.activeCurrency().tla())
    }
    
    fileprivate func amount() -> Float {
        return Float(numberText())!
    }
    
    fileprivate func onDigit(_ digit: String) {
        if number.text! == "0" + SPACE {
            number.text = ""
        }
        if number.text!.replacingOccurrences(of: ".", with: "").characters.count < 7 && noMoreThan2DecimalPlaces() {
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
    
    fileprivate func noMoreThan2DecimalPlaces() -> Bool {
        return !numberText().contains(".") || (numberText() as NSString).substring(from: numberText().characters.count - 2).contains(("."))
    }

    fileprivate func addText(_ char: String) {
        number.text = numberText() + char + SPACE
    }
    
    fileprivate func numberText() -> String {
        return number.text!.trimmingCharacters(in: CharacterSet(charactersIn: SPACE))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Util.center(evenSplitButton)
        Util.center(lobsterButton)
        Util.center(labelButton)
        Util.right(currencyButton)
        update()
        onClear("" as AnyObject)
        typeModal = Modal(viewName: "PaymentType", owner: self)
        helpModal = Modal(viewName: "LobsterHelp", owner: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
        navigationController!.setNavigationBarHidden(false, animated: false)
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        if type == Type.iBorrowed || type == Type.theyBorrowed {
            evenSplitButton.frame = CGRect(x: 0, y: evenSplitButton.frame.origin.y, width: view.frame.width, height: evenSplitButton.frame.height)
            labelButton.removeFromSuperview()
            lobsterButton.removeFromSuperview()
            evenSplitButton.setTitle("Done", for: UIControlState())
        }
    }
}

