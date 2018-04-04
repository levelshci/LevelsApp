//
//  RecommendationViewController.swift
//  Levels
//
//  Created by Jonathan Pereyra on 4/3/18.
//  Copyright © 2018 Jonathan Pereyra. All rights reserved.
//

import UIKit

class RecommendationViewController: UIViewController {
    
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .default

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default

    }
}


