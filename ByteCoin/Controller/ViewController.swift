//  ViewController.swift
//  ByteCoin

import UIKit

class ViewController: UIViewController {
    @IBOutlet var bitcoinPriceLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!

    var coinManager = CoinManager()
    var selectedCoin: String?
    var selectedCurrency: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

// MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinPriceLabel.text = price
            self.currencyLabel.text = currency
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - UIPickerView DataSource & Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return coinManager.coinArray.count
        } else {
            return coinManager.currencyArray.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return String(coinManager.coinArray[row])
        } else {
            return String(coinManager.currencyArray[row])
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            selectedCoin = coinManager.coinArray[row]
        } else {
            selectedCurrency = coinManager.currencyArray[row]
        }

        coinManager.getCoinPrice(forCoin: selectedCoin ?? coinManager.coinArray[1],
                                 forCurrency: selectedCurrency ?? coinManager.currencyArray[4])
    }
}
