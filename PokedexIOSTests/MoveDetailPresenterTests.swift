//
//  MoveDetailPresenterTests.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 31/1/24.
//

import Foundation
import XCTest
@testable import PokedexIOS

final class MoveDetailPresenterTests: XCTestCase {
    
    var moveDetailViewDelegate: MoveDetailViewDelegateMock!
    var apiHelper: ApiHelperMock!
    var fetchpokemonUseCase: FetchPokemonUseCaseMock!
    var moveDTORepresentable: MoveDTOMock!
    
    override func setUp() {
        moveDetailViewDelegate = MoveDetailViewDelegateMock()
        apiHelper = ApiHelperMock()
        fetchpokemonUseCase = FetchPokemonUseCaseMock()
        moveDTORepresentable = MoveDTOMock()
    }
    
    func test_Given_MoveDetailPresenter_When_ShowData_Then_DidUpdateMoveDataFromDelegateIsCalled() {
        //Given
        let pokemonMove = PokemonMove(moveName: "move", moveURL: "www.move.es", moves: [Constants.MoveLearnMethods.LEVEL_METHOD : [(level: 0, game: "Pokemon white")]])
        let sut = DefaultMoveDetailPresenter(apiHelper: apiHelper, fetchPokemonUseCase: fetchpokemonUseCase)
        
        //When
        sut.delegate = moveDetailViewDelegate
        sut.showData(moveDTORepresentable: moveDTORepresentable, pokemonMove: pokemonMove, learnMethod: Constants.MoveLearnMethods.LEVEL_METHOD)
        
        //Then
        XCTAssertEqual(moveDetailViewDelegate.didUpdatePokemonMoveDataHasBeenCalled, true, "Success accessing to Pokemon Move View Delegate - didUpdatePokemonMoveData func.")
    }
    
    func test_Given_MoveDetailPresenter_When_GetMoveDetail_Then_DidUpdatePokemonMoveFromDelegateIsCalled() {
        //Given
        let sut = DefaultMoveDetailPresenter(apiHelper: apiHelper, fetchPokemonUseCase: fetchpokemonUseCase)
        
        //When
        sut.delegate = moveDetailViewDelegate
        sut.getMoveDetail(moveName: "")
        
        //Then
        XCTAssertEqual(moveDetailViewDelegate.didUpdatePokemonMoveHasBeenCalled, true, "Success accessing to Pokemon Move View Delegate - didUpdatePokemonMove func.")
    }
    
}
