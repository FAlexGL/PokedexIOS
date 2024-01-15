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
    func resolve() -> DBPokemonDataSource
    func resolve() -> ApiPokemonDataSource
    func resolve() -> PokemonRepository
}

extension DataDependency where Self: DefaultAppDependency {
    
    func resolve() -> APIHelper {
        DefaultAPIHelper()
    }
    
    func resolve() -> DBHelper {
        DefaultDBHelper()
    }
    
    func resolve() -> DBPokemonDataSource {
        DefaultDBPokemonDataSource(dbHelper: resolve())
    }
    
    func resolve() -> ApiPokemonDataSource {
        DefaultApiPokemonDataSource(apiHelper: resolve())
    }
    
    func resolve() -> PokemonRepository {
        DefaultPokemonRepository(apiDataSource: resolve(), dbDataSource: resolve())
    }
    
}
