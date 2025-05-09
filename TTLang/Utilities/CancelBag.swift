//
//  CancelBag.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import Foundation
import Combine

final class CancelBag {
    fileprivate(set) var subscriptions = [any Cancellable]()
    private let equalToAny: Bool
    
    init(equalToAny: Bool = false) {
        self.equalToAny = equalToAny
    }
    
    func cancel() {
        subscriptions.removeAll()
    }
    
    func isEqual(to other: CancelBag) -> Bool {
        return other === self || other.equalToAny || self.equalToAny
    }
}

extension Cancellable {
    
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.append(self)
    }
}

extension Task: @retroactive Cancellable { }
