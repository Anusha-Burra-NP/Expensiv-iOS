//
//  Helpers.swift
//  Expensiv
//
//  Created by Anusha NP on 11/9/2025.
//
import Foundation

struct Helpers {
    static func getDateFormatter(date: Date?, format: String = "yyyy-MM-dd") -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
