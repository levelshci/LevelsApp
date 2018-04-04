//
//  RecommendationViewController.swift
//  Levels
//
//  Created by Jonathan Pereyra on 4/3/18.
//  Copyright © 2018 Jonathan Pereyra. All rights reserved.
//

import UIKit
import DropDown

class RecommendationViewController: UIViewController, UITextFieldDelegate {
    let categoryDropDown = DropDown()
    let placeDropDown = DropDown()
    var amount = String()
    var activeField: UITextField!
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chooseCategoryUIView: UIView!
    @IBOutlet weak var chooseCategoryButton: UIButton!
    @IBAction func chooseCategory(_ sender: UIButton) {
        categoryDropDown.show()
        placeDropDown.hide()
        
    }
    @IBOutlet weak var choosePlaceUIView: UIView!
    @IBOutlet weak var choosePlaceButton: UIButton!
    @IBAction func choosePlace(_ sender: UIButton) {
        placeDropDown.show()
        categoryDropDown.hide()
        
    }
    
    @IBOutlet weak var amountField: UITextField!
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        view.endEditing(true);
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .default
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.white
        
        // The view to which the drop down will appear on
        categoryDropDown.anchorView = chooseCategoryUIView
        placeDropDown.anchorView = choosePlaceUIView
        
        
        // The list of items to display. Can be changed dynamically
        categoryDropDown.dataSource = ["Food", "Gas"]
        
        
        // Action triggered on selection
        categoryDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseCategoryButton.setTitle(item, for: .normal)
            
            if item == "Food"{
                self?.placeDropDown.dataSource = ["Chipotle", "Walmart", "Vale", "POD Market", "Add New Place..."]
            }
            else {
                self?.placeDropDown.dataSource = ["BP", "Exxon", "Mobil", "Circle K", "Add New Place..."]
            }
        }
        placeDropDown.selectionAction = { [weak self] (index, item) in
            var newPlace = String()
            if item != "Add New Place..." {
                self?.choosePlaceButton.setTitle(item, for: .normal)
            }
            else{
                let alert = UIAlertController(title: "New Place", message: "Enter the name of the place.", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                    let textField = alert.textFields![0] as UITextField
                    newPlace = textField.text!
                    
                    self?.placeDropDown.dataSource.removeLast()
                    self?.placeDropDown.dataSource.append(newPlace)
                    self?.placeDropDown.dataSource.append("Add New Place...")
                    
                    self?.choosePlaceButton.setTitle(newPlace, for: .normal)
                    
                }
                alert.addTextField { (textField) in
                    textField.placeholder = "Name"
                }
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
                
                
            }
        }
        
        amountField!.delegate = self;
        amountField.setRightPaddingPoints(10)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
    //Text Field Delegate Functions
    //Input is happening, show doneButton
    func textFieldDidBeginEditing(_ textField: UITextField) {
        amountField.clearsOnBeginEditing = true;
        amountField.text = "$";
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        activeField?.resignFirstResponder()
        activeField = nil
        return false
    }
    
    //Input is done, hide doneButton and begin calculations
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Assign input to variable subtotalInput
        amount = removeDollarSign(x: amountField.text!);
        let amountAsDble = Double(amount)
        
        //Handle case where input is empty
        if isEmptyString(x: amount) {
            amountField.text = "";
        }
            
            
            //Handle scenario with invalid input
        else if amountAsDble == nil {
            //Create instance of alert
            let invalidInputAlert = UIAlertController(title: "Invalid Amount", message: "Please enter a valid amount!", preferredStyle: UIAlertControllerStyle.alert)
            
            //Add an action (button)
            invalidInputAlert.addAction(UIAlertAction(title: "Oops!", style: UIAlertActionStyle.default, handler: nil))
            
            //Show the alert
            self.present(invalidInputAlert, animated: true, completion: nil)
            
            //Reset subtotalInputField
            amountField.text = "";
            
        }
            
        else {
            //Input is OK print calculations
            let roundInput =  NSString(format:"%.2f", Double(amount)!) as String;
            //Format inout with dollar assign, after optional rounding
            self.amountField.text = "$" + roundInput;
            
        }
    }
    
    //The Bools
    func isEmptyString(x: String)-> Bool{
        if (x == "" ){
            return true;
        }
        else{
            return false;
        }
    }
    
    
    func removeDollarSign(x: String)->String{
        let rangeSubtotal = x.characters.index(x.startIndex, offsetBy: 1)..<x.endIndex
        return String(x[rangeSubtotal])
        //        self.priceAsDouble = Double(self.priceAsString!);
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
    
    
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

