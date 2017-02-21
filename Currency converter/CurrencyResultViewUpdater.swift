//
//  CurrencyResultViewUpdater.swift
//  Currency converter
//
//  Created by Vladislav Orlov on 21.02.17.
//  Copyright © 2017 Vladislav Orlov. All rights reserved.
//

import UIKit

protocol CurrencyResultViewUpdater {
    func updateResult(baseAmount: Int, baseCurrency: String, toCurrency: String)
}
