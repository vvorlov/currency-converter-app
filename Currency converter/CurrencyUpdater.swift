//
//  CurrencyUpdater.swift
//  Currency converter
//
//  Created by Vladislav Orlov on 20.02.17.
//  Copyright © 2017 Vladislav Orlov. All rights reserved.
//

import UIKit

protocol CurrencyConverter {
    func getCurrencyTitles(completion: @escaping([String]) -> Void)
    func convert(from original: String, to dest: String, completion: @escaping(Float) -> Void)
}
