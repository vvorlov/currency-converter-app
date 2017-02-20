//
//  CurrencyUpdater.swift
//  Currency converter
//
//  Created by Vladislav Orlov on 20.02.17.
//  Copyright © 2017 Vladislav Orlov. All rights reserved.
//

import UIKit

protocol CurrencyConverter {
    func getCurrencyTitles() -> [String]
    func convert(amount: Int, from original: String, to dest: String) -> Float
}
