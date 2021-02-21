//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String )
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/ETH"
    let apiKey = "1126C12C-9D7E-4C2D-874F-78513A7CAF82"
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    // URL Session code to make call
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
        
        if let url = URL(string: urlString){
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    
                    if let safeData = data{
                        if let coinPrice = self.parseJSON(safeData){
                            let priceString = String(format: "%.2f", coinPrice)
                            self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                        }
                    }
                }
                
                //Start the task
                task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
            let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
            print(lastPrice)
            
            return lastPrice
        } catch {
            delegate?.didFailWithError(error : error)
            return nil
        }
        
    }

}


    
    
