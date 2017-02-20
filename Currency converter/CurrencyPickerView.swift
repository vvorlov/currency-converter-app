//
//  CurrencyPickerView.swift
//  Currency converter
//
//  Created by Vladislav Orlov on 20.02.17.
//  Copyright © 2017 Vladislav Orlov. All rights reserved.
//

import UIKit

class CurrencyPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    fileprivate let amountTitles = ["1", "5", "10", "50", "100", "500", "1K", "10K", "100K", "1M"]
    fileprivate var converter: CurrencyConverter?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    func setConverter(converter: CurrencyConverter) {
        self.converter = converter
    }
    
    // MARK: Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let conv = converter, (component == 1 || component == 3) {
            return conv.getCurrencyTitles().count
        }
        
        if component == 0 {
            return getAmountValuesCount()
        }
        
        return 0
    }
    
    // MARK: Delegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        switch component {
        
        case 0:
            let value = getAmountTitle(for: row)
            return NSAttributedString(string: value,
                                      attributes: [NSForegroundColorAttributeName : AppColors.amountColor])
        case 1:
            let value = converter?.getCurrencyTitles()[row]
            return NSAttributedString(string: value!,
                                      attributes: [NSForegroundColorAttributeName : AppColors.originalCurrencyColor])
        case 3:
            let value = converter?.getCurrencyTitles()[row]
            return NSAttributedString(string: value!,
                                      attributes: [NSForegroundColorAttributeName : AppColors.destinationCurrencyColor])
        default:
            return nil
        }
    }
    
    // MARK: - Amount
    
    func getAmountValuesCount() -> Int {
        return amountTitles.count
    }
    
    func getAmountTitle(for row: Int) -> String {
        return amountTitles[row]
    }
}
