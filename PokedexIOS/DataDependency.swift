//
//  DataDependency.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 8/1/24.
//

import Foundation

protocol DataDependency {
    func resolve() -> APIHelper
}

extension DataDependency where Self: DefaultAppDependency {
    func resolve() -> APIHelper {
        DefaultAPIHelper()
    }
}
