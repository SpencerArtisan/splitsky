//
//  FrontViewController.swift
//  Splitsky
//
//  Created by Spencer Ward on 04/09/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {

    @IBOutlet weak var blackLabel: UILabel!
    @IBOutlet weak var iBorrowed: UIButton!
    @IBOutlet weak var theyBorrowed: UIButton!
    @IBOutlet weak var iPaidBill: UIButton!
    @IBOutlet weak var theyPaidBill: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iBorrowed.titleLabel?.textAlignment = NSTextAlignment.Center
        theyBorrowed.titleLabel?.textAlignment = NSTextAlignment.Center
        iPaidBill.titleLabel?.textAlignment = NSTextAlignment.Center
        theyPaidBill.titleLabel?.textAlignment = NSTextAlignment.Center
        // Do any additional setup after loading the view.
        
        Data.set(PaymentRepository.load())
        
        blackLabel.text = getBlackLabel()
        
        theyBorrowed.setTitle(getButtonLabel(Type.theyBorrowed), forState: UIControlState.Normal)
        theyPaidBill.setTitle(getButtonLabel(Type.theyPaid), forState: UIControlState.Normal)
    }

    override func viewWillAppear(animated: Bool) {
      //  navigationController!.setNavigationBarHidden(true, animated: false)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dest: ViewController = segue.destinationViewController as! ViewController
        dest.type = Type.fromCode(segue.identifier!)
        dest.doneButtonTitle = getButtonLabel(dest.type!)
        navigationController!.setNavigationBarHidden(false, animated: false)
    }
    
    private func getBlackLabel() -> String {
        var text = Data.listName()
        
        let totalOwingsAmount: Float = Data.totalOwings()
        if (abs(totalOwingsAmount) < 0.01) {
            text = text + " owes me nothing"
        } else {
            text = text + (totalOwingsAmount < 0 ? " is owed " : " owes me ")
            text = text + Util.toMoney(abs(totalOwingsAmount))
        }
        return text
    }
    
    private func getButtonLabel(type: Type) -> String {
        let they = Data.isNamed() ? Data.listName().capitalizedString : "They"
        return type == Type.iPaid ? "I\nPaid Bill" :
            (type == Type.theyPaid ? "\(they)\nPaid Bill" :
                (type == Type.iBorrowed ? "I\nBorrowed" :
                    "\(they)\nBorrowed"))
    }
}
