//
//  DataDependency.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 8/1/24.
//

import Foundation

protocol DataDependency {
    func resolve() -> APIRepository
    func resolve() -> DefaultDBHelper
}

extension DataDependency where Self: DefaultAppDependency {
    func resolve() -> APIRepository {
        DefaultAPIHelper.share
    }
    
    func resolve() -> DefaultDBHelper {
        DefaultDBHelper.shared
    }
}
