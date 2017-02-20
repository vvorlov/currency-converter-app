//
//  ViewController.swift
//  Currency converter
//
//  Created by Vladislav Orlov on 20.02.17.
//  Copyright © 2017 Vladislav Orlov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currencyPicker: CurrencyPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.setConverter(converter: FixerCurrencyConverter())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

