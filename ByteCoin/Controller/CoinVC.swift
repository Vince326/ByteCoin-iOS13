//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit


class CoinVC: UIViewController {
    @IBOutlet var currencyLbl: UILabel!
    @IBOutlet var bitcoinLbl: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!
    
    
    
    var coinManager = CoinManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
    
    
    
}

// MARK: - CoinManager Delegate Code
extension CoinVC : CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        /// Updates UI done on the background thread because
        DispatchQueue.main.async {
            self.bitcoinLbl.text = price
            self.currencyLbl.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
// MARK: - PickerView Delegate Code
extension CoinVC : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Returns the values in the currencyArray as titles for the pickeView
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(coinManager.currencyArray[row])
        let chosenCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: chosenCurrency)
    }
}

//MARK: - Picker View Data Source
extension CoinVC : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

