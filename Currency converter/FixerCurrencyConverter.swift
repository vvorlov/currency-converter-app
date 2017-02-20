//
//  FixerCurrencyConverter.swift
//  Currency converter
//
//  Created by Vladislav Orlov on 20.02.17.
//  Copyright © 2017 Vladislav Orlov. All rights reserved.
//

import UIKit

class FixerCurrencyConverter: NSObject, CurrencyConverter {
    func getCurrencyTitles() -> [String] {
        return ["RUB", "USD", "UAH"]
    }
    
    func convert(amount: Int, from original: String, to dest: String) -> Float {
        return 0.0
    }
}
