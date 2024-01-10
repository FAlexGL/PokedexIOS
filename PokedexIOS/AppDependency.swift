//
//  AppDependency.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 8/1/24.
//

import Foundation


protocol AppDependency {
    
}

class DefaultAppDependency {

}

extension DefaultAppDependency : AppDependency, PresentationDependency, DataDependency {
    
}
