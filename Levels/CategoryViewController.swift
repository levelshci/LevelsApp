//
//  CategoryViewController.swift
//  Levels
//
//  Created by Jonathan Pereyra on 4/4/18.
//  Copyright © 2018 Jonathan Pereyra. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITextFieldDelegate {
    
    var amount: String!
    @IBOutlet weak var newCategory: UITextField!
    @IBOutlet weak var overallTotal: UILabel!
    @IBOutlet weak var newAmount: UITextField!
    
    @IBAction func setCategories(_ sender: Any) {
        let defaults = UserDefaults.standard
        var categories = ["FOOD", "GAS", "CLOTHES", "FUN"]
        defaults.set(categories, forKey: "categories")
        
        categories.append(newCategory.text!.uppercased())
        categories.append("OVERALL")
        defaults.set(categories, forKey: "categories")

    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        view.endEditing(true);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
  
        
        newAmount.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Text Field Delegate Functions
    //Input is happening, show doneButton
    func textFieldDidBeginEditing(_ textField: UITextField) {
        newAmount.clearsOnBeginEditing = true;
        newAmount.text = "$";
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Input is done, hide doneButton and begin calculations
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Assign input to variable subtotalInput
        amount = removeDollarSign(x: newAmount.text!);
        let amountAsDble = Double(amount)
        
        //Handle case where input is empty
        if isEmptyString(x: amount) {
            newAmount.text = "";
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
            newAmount.text = "";
            
        }
            
        else {
            //Input is OK print calculations
            let roundInput =  NSString(format:"%.2f", Double(amount)!) as String;
            //Format inout with dollar assign, after optional rounding
            self.newAmount.text = "$" + roundInput;
            overallTotal.text = "$" + (NSString(format:"%.2f", 295.00 + Double(amount)!) as String) as String
            
            let defaults = UserDefaults.standard
            
            let cap = [160.0, 35.0, 50.0, 50.0, Double(amount), Double(NSString(format:"%.2f", 295.00 + Double(amount)!) as String)]
            defaults.set(cap, forKey: "cap")
                        
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
    
    
    
}
