//
//  ErrorVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import UIKit

class ErrorVC: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func buttonPusshed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
