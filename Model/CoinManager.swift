//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Дмитрий Х on 30.08.22.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(_ CoinManager: CoinManager, currency: CurrencyModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["USD","EUR","RUB","GBP","AUD", "BRL","CAD","CNY","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","SEK","SGD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(ApiKey().baseURL)/\(currency)?apikey=\(ApiKey().apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let currency = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCurrency(self, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CurrencyModel? {
        
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            //try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CurrencyData.self, from: data)
            
            //Get the last property from the decoded data.
            let lastPrice = decodedData.rate
            let currencyID = decodedData.asset_id_quote
            let currency = CurrencyModel(rate: lastPrice, currencyID: currencyID)
            return currency
            
        } catch {
            //Catch and print any errors.
            print(error)
            return nil
        }
    }
}
