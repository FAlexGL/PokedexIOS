//
//  DataDependency.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 8/1/24.
//

import Foundation

protocol DataDependency {
    func resolve() -> APIHelper
    func resolve() -> DBHelper
}

extension DataDependency where Self: DefaultAppDependency {
    func resolve() -> APIHelper {
        DefaultAPIHelper.share
    }
    
    func resolve() -> DBHelper {
        DefaultDBHelper.shared
    }
}
