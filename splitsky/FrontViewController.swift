//
//  FrontViewController.swift
//  Splitsky
//
//  Created by Spencer Ward on 04/09/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {


    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var summaryButton: UIButton!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var iBorrowed: UIButton!
    @IBOutlet weak var theyBorrowed: UIButton!
    @IBOutlet weak var iPaidBill: UIButton!
    @IBOutlet weak var theyPaidBill: UIButton!
    @IBOutlet weak var breakdownButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Data.set(PaymentRepository.load())
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(true, animated: false)
        update()
    }
    
    fileprivate func update() {
        style(theyBorrowed, text: FrontViewController.getButtonLabel(Type.theyBorrowed))
        style(theyPaidBill, text: FrontViewController.getButtonLabel(Type.theyPaid))
        style(iBorrowed, text: FrontViewController.getButtonLabel(Type.iBorrowed))
        style(iPaidBill, text:FrontViewController.getButtonLabel(Type.iPaid))
        style(breakdownButton, text: "\(Data.listName().capitalized)\nBreakdown")
        listNameLabel.text = Data.listName().capitalized
        Util.setText(summaryButton, text: Data.owingsSummary())
        Util.setText(currencyButton, text: Data.activeCurrency().tla())
    }
    
    fileprivate func style(_ button: UIButton, text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 16 // Whatever line spacing you want in points
        paragraphStyle.alignment  = NSTextAlignment.center
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: button.currentTitleColor, range:NSMakeRange(0, attributedString.length))
        
        button.setAttributedTitle(attributedString, for: UIControlState())
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dest: ViewController? = segue.destination as? ViewController
        if dest != nil {
            dest!.type = Type.fromCode(segue.identifier!)
        }
    }
    
    static func getButtonLabel(_ type: Type) -> String {
        let they = Data.listName().capitalized
        return type == Type.iPaid ? "I\nPaid Bill" :
            (type == Type.theyPaid ? "\(they)\nPaid Bill" :
                (type == Type.iBorrowed ? "\(they)\nGave Me" :
                    "I Gave\n\(they)"))
    }
}
