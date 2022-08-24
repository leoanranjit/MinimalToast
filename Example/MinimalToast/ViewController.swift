//
//  ViewController.swift
//  MinimalToast
//
//  Created by leoanranjit on 08/22/2022.
//  Copyright (c) 2022 leoanranjit. All rights reserved.
//

import UIKit
import MinimalToast

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnSuccess: UIButton!
    @IBOutlet weak var btnFailed: UIButton!
    @IBOutlet weak var btnWarning: UIButton!
    @IBOutlet weak var btnAnimates: UIButton!
    
    // MARK: - Constants and variables
    var state : Toast.State = .success
        
    // MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSuccess.isSelected = true
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: - IBAction Functions
    @IBAction func btnState(_ sender: UIButton) {
        
        sender.isSelected = true
        
        let btnArray : [UIButton] = [btnSuccess, btnFailed, btnWarning]
        
        for i in btnArray {
            
            if i != sender {
                
                i.isSelected = false
                
            }
            
        }
        
        switch sender.tag {
            
        case 0:
            
            self.state = .success
            
        case 1:
            
            self.state = .failed
            
        case 2:
            
            self.state = .warning
            
        default:
            
            break
            
        }
        
    }
    
    @IBAction func btnShowToast(_ sender: Any) {
        
        if txtMessage.text == "" {
            
            self.txtMessage.placeholder = "Enter Toast Message First"
            
        }else{
                        
            Toast.showToast(state: self.state, message: txtMessage.text!)
            
        }
        
    }
    
    @IBAction func btnAnimates(_ sender: Any) {
                
        Toast.animates = !Toast.animates
        
        btnAnimates.isSelected = !btnAnimates.isSelected
        
        print(Toast.animates)
        
    }
    
    // MARK: - Additional Functions
    
}


