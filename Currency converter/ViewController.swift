//
//  ViewController.swift
//  Currency converter
//
//  Created by Vladislav Orlov on 20.02.17.
//  Copyright © 2017 Vladislav Orlov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CurrencyResultViewUpdater {

    @IBOutlet weak var currencyPicker: CurrencyPickerView!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var resCurrencyLabel: UILabel!
    
    fileprivate var currencyConverter: CurrencyConverter = FixerCurrencyConverter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.setConverter(converter: currencyConverter)
        currencyPicker.setResultViewUpdater(updater: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CurrencyValueViewUpdater
    
    func updateResult(baseAmount: Int, baseCurrency: String, toCurrency: String) {
        baseCurrencyLabel.text = "\(baseAmount) " + baseCurrency
        
        currencyConverter.convert(from: baseCurrency, to: toCurrency) { res in
            DispatchQueue.main.async(execute: {
                self.resCurrencyLabel.text = "\(res) " + toCurrency
            })
        }
    }

}

