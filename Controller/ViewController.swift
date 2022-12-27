//
//  ViewController.swift
//  ByteCoin
//
//  Created by Дмитрий Х on 30.08.22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource {
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var coinManager = CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

// MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didUpdateCurrency(_ CoinManager: CoinManager, currency: CurrencyModel) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency.currencyID
            self.bitcoinLabel.text = currency.currencyString
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
