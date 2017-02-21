//
//  FixerCurrencyConverter.swift
//  Currency converter
//
//  Created by Vladislav Orlov on 20.02.17.
//  Copyright © 2017 Vladislav Orlov. All rights reserved.
//

import UIKit

class FixerCurrencyConverter: NSObject, CurrencyConverter {
    
    fileprivate let url = "https://api.fixer.io/latest?base="
    
    fileprivate var currencies: [String : Double]? = nil
    fileprivate var baseCurrency: String? = nil
    
    
    // MARK: - CurrencyConverter
    
    func isAvailable(completion: @escaping (Bool) -> Void) {
        self.requestCurrencyRates(baseCurrency: "RUB") { (data, error) in
            if let _ = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    func getCurrencyTitles(completion: @escaping([String]) -> Void) {
        if let rates = currencies {
            completion(Array(rates.keys))
            return
        }
        
        self.retrieveCurrencyRate(baseCurrency: "RUB", toCurrency: nil) { value in
            completion(Array(self.currencies!.keys))
        }
    }
    
    func convert(from original: String, to dest: String, completion: @escaping(Float) -> Void) {
        if let rates = currencies, baseCurrency == original {
            if let rate = rates[dest] {
                completion(Float(rate))
                return
            }
        }
        
        self.retrieveCurrencyRate(baseCurrency: original, toCurrency: dest, completion: completion)
    }
    
    // MARK: - Data fetch
    
    fileprivate func retrieveCurrencyRate(baseCurrency: String, toCurrency: String?,
                                          completion: @escaping(Float) -> Void) {
        
        self.requestCurrencyRates(baseCurrency: baseCurrency) { [weak self] (data, error) in
            guard error == nil, let strongSelf = self,
                strongSelf.parseCurrencyRatesResponse(data: data),
                let rates = strongSelf.currencies else {
                    return
            }
            
            var rate: Float = 0.0
            
            if let destCurrency = toCurrency, let res = rates[destCurrency] {
                rate = Float(res)
            }
            
            completion(rate)
            
        }
        
        let dataTask = URLSession.shared.dataTask(with: URL(string: url + baseCurrency)!) {
            (dataReceived, response, error) in
        }
        
        dataTask.resume()
    }
    
    fileprivate func requestCurrencyRates(baseCurrency: String, parseHandler: @escaping (Data?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: url + baseCurrency)!)
        request.timeoutInterval = 5
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            (dataReceived, response, error) in
            parseHandler(dataReceived, error)
        }
        
        dataTask.resume()
    }
    
    fileprivate func parseCurrencyRatesResponse(data: Data?) -> Bool {
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any>
            
            if let parsedJSON = json {
                print("\(parsedJSON)")
                
                if let base = parsedJSON["base"] as? String {
                    baseCurrency = base
                } else {
                    NSLog("No \"base\" fields found")
                    return false
                }
                
                if let rates = parsedJSON["rates"] as? Dictionary<String, Double> {
                    currencies = rates
                    
                    //add base currency for the destination currency
                    currencies![baseCurrency!] = 0.0
                } else {
                    NSLog("No \"rates\" field found")
                    return false
                }
            } else {
                NSLog("No JSON value parsed")
                return false
            }
        } catch {
            NSLog(error.localizedDescription)
            return false
        }
        
        return true
    }
}
