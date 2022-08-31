//
//  CurrencyModel.swift
//  ByteCoin
//
//  Created by Дмитрий Х on 30.08.22.
//

struct CurrencyModel {
    
    let rate: Double
    let currencyID: String
    
    var currencyString: String {
        return String(format: "%.2f", rate)
    }
}

