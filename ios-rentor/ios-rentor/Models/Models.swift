//
//  Models.swift
//  ios-rentor
//
//  Created by Thomas on 21/12/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import SwiftUI

internal struct Rentor: Codable, Hashable, MockedProtocol {
    let date: Date?
    let name: String?
    let price: Double
    let rentPrice: Double
    let cashFlow: Double
    let percentage: Double
    var offset: CGFloat
    var isSwiped: Bool
}

extension Rentor: Identifiable {
    var id: UUID { UUID() }
}

extension Rentor: Equatable {
    static func == (lhs: Rentor, rhs: Rentor) -> Bool {
        return lhs.cashFlow == rhs.cashFlow &&
            lhs.date == rhs.date &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.price == rhs.price &&
            lhs.rentPrice == rhs.rentPrice
    }
}
