//
//  DateFormatterManager.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 09.05.2025.
//

import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()

    private var inputFormatters: [String: DateFormatter] = [:]
    private var outputFormatters: [String: [String: DateFormatter]] = [:]

    private let lock = NSLock()

    private init() {}

    func formattedDate(from string: String,
                       fromFormat: String = "yyyy-MM-dd",
                       toFormat: String = "d MMMM yyyy",
                       localeIdentifier: String = "en_US") -> String? {
        
        lock.lock()
        defer { lock.unlock() }

        let inputFormatter = inputFormatter(for: fromFormat)
        guard let date = inputFormatter.date(from: string) else {
            return nil
        }

        let outputFormatter = outputFormatter(for: toFormat, locale: localeIdentifier)
        return outputFormatter.string(from: date)
    }

    private func inputFormatter(for format: String) -> DateFormatter {
        if let formatter = inputFormatters[format] {
            return formatter
        }

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatters[format] = formatter
        return formatter
    }

    private func outputFormatter(for format: String, locale: String) -> DateFormatter {
        if let formatter = outputFormatters[locale]?[format] {
            return formatter
        }

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: locale)

        if outputFormatters[locale] == nil {
            outputFormatters[locale] = [:]
        }
        outputFormatters[locale]?[format] = formatter
        return formatter
    }
}
