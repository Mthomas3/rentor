//
//  Middleware.swift
//  ios-rentor
//
//  Created by Thomas on 12/02/2021.
//  Copyright © 2021 Thomas. All rights reserved.
//

import Foundation
import Combine

internal typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>?

internal protocol MiddlewareProtocol {
    func middleware() -> Middleware<AppState, AppAction>
}
