//
//  Helpers.swift
//  TTLangTests
//
//  Created by Yannis Lang on 20/03/2025.
//

import Foundation

// MARK: - Errors

enum MockError: Swift.Error {
    case valueNotSet
    case codeDataModel
}

extension NSError {
    static var test: NSError {
        return NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
    }
}
