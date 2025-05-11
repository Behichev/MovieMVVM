//
//  String+Extension.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 09.05.2025.
//

import Foundation

extension String {
    func formattedDate(fromFormat: String = "yyyy-MM-dd", toFormat: String = "d MMMM yyyy", localeIdentifier: String = "en_US") -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = fromFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") 

        guard let date = inputFormatter.date(from: self) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: localeIdentifier)
        outputFormatter.dateFormat = toFormat

        return outputFormatter.string(from: date)
    }
}
