//
//  MovesListPresenterTests.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 31/1/24.
//

import Foundation
import XCTest
@testable import PokedexIOS

final class MovesListPresenterTests: XCTestCase {
    
    var dbHelper: DBHelperMock!
    var coordinator: MovesCoordinatorMock!
    
    override func setUp() {
        dbHelper = DBHelperMock()
        coordinator = MovesCoordinatorMock()
    }
    
    func test_Given_MoveListPresenter_When_MovesListPresenter_Then_returnNumberofMoves() {
        //Given
        let pokemonMove = PokemonMove(moveName: "move", moveURL: "www.move.es", moves: [Constants.MoveLearnMethods.LEVEL_METHOD : [(level: 0, game: "Pokemon white")]])
        let sut = DefaultMovesListPresenter(dbHelper: dbHelper, coordinator: coordinator)
        
        //When
        let numberOfMoves = sut.numberOfRowsInSection(pokemonMoves: [pokemonMove])
        
        //Then
        XCTAssertEqual(numberOfMoves, 1, "Success getting the number of moves")
    }
    
    func test_Given_MoveListPresenter_When_DidSelectRowAt_Then_returnNumberofMoves() {
        //Given
        let sut = DefaultMovesListPresenter(dbHelper: dbHelper, coordinator: coordinator)
        
        //When
        let pokemonMove = PokemonMove(moveName: "move", moveURL: "www.move.es", moves: [Constants.MoveLearnMethods.LEVEL_METHOD : [(level: 0, game: "Pokemon white")]])
        sut.didSelectRowAt(pokemonMoves: [pokemonMove], movePosition: 0, learnMethod: Constants.MoveLearnMethods.LEVEL_METHOD)
        
        //Then
        XCTAssertEqual(coordinator.goToMoveDetailHasBeenCalled, true, "Success accessing to MovesCoordinator - goToMoveDetail func.")
    }
    
}
