//  CoinManager.swift
//  ByteCoin

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?

    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "9F015A84-5F85-4239-B17E-45CA611CAC64"

    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    let coinArray = ["DOGE", "BTC", "ETHE", "USDT", "SHIB", "XRP"]

    func getCoinPrice(forCoin coin: String, forCurrency currency: String) {
        let urlString = "\(baseURL)/\(coin)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        print("Currency : \(currency) \nCoin : \(coin)")

        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(roundToPlaces(bitcoinPrice, places: 3, rule: .down))
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

// Define decimals without rounding

func roundToPlaces(_ value: Double, places: Int, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Double {
    let divisor = pow(10.0, Double(places))
    return (value * divisor).rounded(rule) / divisor
}
