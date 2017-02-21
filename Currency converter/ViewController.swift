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
    
    @IBOutlet weak var internetConnectionView: UIView!
    @IBOutlet weak var internetConnectionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var currencyConverter: CurrencyConverter = FixerCurrencyConverter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyConverter.isAvailable() {
            available in
            
            DispatchQueue.main.async(execute: {
                guard available else {
                    self.noInternet()
                    return
                }
                
                self.proceedData()
            })
        }
        
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
        activityIndicator.startAnimating()
        resCurrencyLabel.isHidden = true
        
        currencyConverter.convert(from: baseCurrency, to: toCurrency) { res in
            DispatchQueue.main.async(execute: {
                self.resCurrencyLabel.text = "\(res * Float(baseAmount)) " + toCurrency
                self.activityIndicator.stopAnimating()
                self.resCurrencyLabel.isHidden = false
            })
        }
    }
    
    // MARK: - Internet connection
    
    func noInternet() {
        self.internetConnectionLabel.text = "Отсутствует\n соединение с сервером"
        self.internetConnectionLabel.numberOfLines = 3
        self.activityIndicator.stopAnimating()
    }
    
    func proceedData() {
        self.internetConnectionView.isHidden = true
    }

}

