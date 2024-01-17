//
//  Double.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/23/23.
//

import Foundation

extension Double {
    private var doubleFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func toDouble() -> String {
        return doubleFormatter.string(for: self) ?? ""
    }
}
