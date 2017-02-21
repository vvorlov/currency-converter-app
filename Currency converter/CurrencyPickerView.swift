//
//  CurrencyPickerView.swift
//  Currency converter
//
//  Created by Vladislav Orlov on 20.02.17.
//  Copyright © 2017 Vladislav Orlov. All rights reserved.
//

import UIKit

class CurrencyPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    fileprivate let amountTitles = ["1", "10", "50", "100", "1K", "10K", "100K"]
    fileprivate var currencyTitles: [String] = []
    
    fileprivate var converter: CurrencyConverter?
    fileprivate var viewUpdater: CurrencyResultViewUpdater?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    func setConverter(converter: CurrencyConverter) {
        self.converter = converter
        
        converter.getCurrencyTitles() { titles in
            self.currencyTitles = titles.sorted()
            
            self.selectMiddle()
        }
    }
    
    func setResultViewUpdater(updater: CurrencyResultViewUpdater) {
        self.viewUpdater = updater
    }
    
    func selectMiddle() {
        DispatchQueue.main.async(execute: {
            
            self.reloadAllComponents()
            
            for currComponent in 0..<self.numberOfComponents {
                let defaultIndex = self.getDefaultIndex(forComponent: currComponent)
                let middle = defaultIndex > 0 ? defaultIndex : self.numberOfRows(inComponent: currComponent) / 2
                self.selectRow(middle, inComponent: currComponent,
                               animated: true)
            }
            
            self.updateView()
        })
    }
    
    func getDefaultIndex(forComponent: Int) -> Int{
        switch forComponent {
        case 0:
            if let v = amountTitles.index(of: "100") {
                return v
            }
        case 1:
            if let v = currencyTitles.index(of: "USD") {
                return v
            }
        case 3:
            if let v = currenciesExceptBase().index(of: "RUB") {
                return v
            }
        default:
            return -1
        }
        
        return -1
    }
    
    // MARK: Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(component) {
        case 0:
            return getAmountValuesCount()
        case 1:
            return currencyTitles.count
        case 3:
            return currenciesExceptBase().count
        default:
            return 0
        }
    }
    
    func currenciesExceptBase() -> [String] {
        guard currencyTitles.count > 0 else {
            return currencyTitles
        }
        
        var currenciesExceptBase = currencyTitles
        currenciesExceptBase.remove(at: self.selectedRow(inComponent: 1))
        return currenciesExceptBase
    }
    
    // MARK: Delegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        switch component {
        
        case 0:
            let value = getAmountTitle(for: row)
            return NSAttributedString(string: value,
                                      attributes: [NSForegroundColorAttributeName : AppColors.amountColor])
        case 1:
            let value = currencyTitles[row]
            return NSAttributedString(string: value,
                                      attributes: [NSForegroundColorAttributeName : AppColors.originalCurrencyColor])
        case 3:
            let value = currenciesExceptBase()[row]
            return NSAttributedString(string: value,
                                      attributes: [NSForegroundColorAttributeName : AppColors.destinationCurrencyColor])
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.reloadComponent(3)
        
        updateView()
    }
    
    func updateView() {
        let amount = getSelectedAmount()
        let base = currencyTitles[selectedRow(inComponent: 1)]
        let to = currenciesExceptBase()[selectedRow(inComponent: 3)]
        viewUpdater?.updateResult(baseAmount: amount, baseCurrency: base, toCurrency: to)
    }
    
    // MARK: - Amount
    
    func getSelectedAmount() -> Int {
        var value = amountTitles[selectedRow(inComponent: 0)]
        value = (value as NSString).replacingOccurrences(of: "K", with: "000")
        value = (value as NSString).replacingOccurrences(of: "M", with: "000000")
        return Int(value)!
    }
    
    func getAmountValuesCount() -> Int {
        return amountTitles.count
    }
    
    func getAmountTitle(for row: Int) -> String {
        return amountTitles[row]
    }
}
