//
//  ViewController.swift
//  convector
//
//  Created by Kolya on 09.11.16.
//  Copyright © 2016 Kolya. All rights reserved.
//

import UIKit


class ViewController: UIViewController, SaveUnits {
    
    @IBOutlet weak var displayLable: UILabel!
    @IBOutlet weak var LableTwo: UILabel!
    
    @IBOutlet weak var rotateButtn: UIButton!
    @IBOutlet weak var unitsText: UIButton!
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
   
    @IBOutlet weak var viewOne: UIView!
    
    
    var timer: Timer!
    var degree = CGFloat(M_PI/180)
    var inTheType  = false
    var flags = false
    
    var nameUnits = String()
    
    var min = 1.1
    
    override func viewDidLoad(){
        
        imageOne.addSubview(displayLable)
        imageTwo.addSubview(LableTwo)
        super.viewDidLoad()
    }
    
    @IBAction func digitButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        let  digit = sender.currentTitle!
        
        if displayLable.text == "․" {
            return
        }
        
        if inTheType {
            if !(digit == "." && (displayLable.text!.range(of: ".") != nil)) {
                displayLable.text = displayLable.text! + digit
            }
        }else {
            displayLable.text = (digit == "." ? "0." : digit)
            inTheType = true
        }
        
        if inTheType == true {
          LableTwo.text = String(Double(displayLable.text!)! * Double(min))
            
        }
    }
    
    @IBAction func buttnClear(_ sender: UIButton) {
        if inTheType == true {
            displayLable.text = "0"
           LableTwo.text = "0"
        }
        inTheType = false
    }
    
    @IBAction func buttnUnits(_ sender: AnyObject) {
        
        unitsText.setTitle(nameUnits, for: .normal)
        
        let unitController  = self.storyboard!.instantiateViewController(withIdentifier: "UnitsTableViewController") as! UnitsTableViewController
        unitController.delegate = self
        self.navigationController?.pushViewController(unitController, animated: true)
    }
    
    @IBAction func buttnRot(_ sender: AnyObject) {
        rotateBnt(buttn: rotateButtn)
        imageTransform(one:imageOne, two:imageTwo)
    }

    func save(name: String, value: Double) {
        nameUnits = name
        min = value
    }
    
    func rotateBnt(buttn : UIButton ){
        
        let duration = 0.2
        let delay = 0
        let angle = 3.14
        
        UIView.animate(withDuration: duration, delay: TimeInterval(delay), options: [], animations: {
            buttn.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        }) { (finised ) -> Void in
            buttn.transform = CGAffineTransform.identity
        }
    }
    
    func imageTransform(one : UIImageView, two: UIImageView ) {
        
        let duration = 0.5
        let delay = 0
        
        let oneX = 0
        let dowOneY = 140
        let upOneY = -10
        
        let twoX = 0
        let twoY = -140
        let upTwoY = -10
        
        if flags == false {
            UIView.animate(withDuration: duration, delay: TimeInterval(delay), options: UIViewAnimationOptions.curveLinear, animations: {
                one.transform = CGAffineTransform(translationX: CGFloat(oneX), y: CGFloat(dowOneY))
            }) { (finised) -> Void in
                
                self.flags = true
            }
        } else {
            UIView.animate(withDuration: duration, delay: TimeInterval(delay), options: UIViewAnimationOptions.curveLinear, animations: {
                one.transform = CGAffineTransform(translationX: CGFloat(oneX), y: CGFloat(upOneY))
            }) { (finised) -> Void in
                self.flags = false
            }
        }
        
        if flags == false {
            UIView.animate(withDuration: duration, delay: TimeInterval(delay), options: UIViewAnimationOptions.curveLinear, animations: {
                two.transform = CGAffineTransform(translationX: CGFloat(twoX), y: CGFloat(twoY))
            }) { (finised) -> Void in
                self.flags = true
            }
        }else{
            UIView.animate(withDuration: duration, delay: TimeInterval(delay), options: UIViewAnimationOptions.curveLinear, animations: {
                two.transform = CGAffineTransform(translationX: CGFloat(twoX), y: CGFloat(upTwoY))
            }) { (finised) -> Void in
                self.flags = false}
        }
    }
}


