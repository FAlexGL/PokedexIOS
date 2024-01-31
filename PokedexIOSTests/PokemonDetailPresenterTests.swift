//
//  PokemonDetailPresenterTests.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 31/1/24.
//

import Foundation
import XCTest
@testable import PokedexIOS

final class PokemonDetailPresenterTests: XCTestCase {
    
    var apiHelperMock: ApiHelperMock!
    var coordinatorMock: PokemonCoordinatorMock!
    var fetchPokemonUseCaseMock: FetchPokemonUseCaseMock!
    var updateFavouritePokemonsUseCaseMock: UpdateFavouritePokemonsUseCaseMock!
    var fetchFavouritePokemonsUseCaseMock: FetchFavouritePokemonsUseCaseMock!
    var spritesMock: SpritesMock!
    var pokemonMock: PokemonMock!
    
    override func setUp() {
        apiHelperMock = ApiHelperMock()
        coordinatorMock = PokemonCoordinatorMock()
        fetchPokemonUseCaseMock = FetchPokemonUseCaseMock()
        updateFavouritePokemonsUseCaseMock = UpdateFavouritePokemonsUseCaseMock()
        fetchFavouritePokemonsUseCaseMock = FetchFavouritePokemonsUseCaseMock()
        spritesMock = SpritesMock()
        pokemonMock = PokemonMock()
    }
    
    func test_Given_PokemonDetailPresenter_When_MovesButtonPushed_Then_PokemonCoordinatorIsCalled() {
        //Given
        let sut = DefaultPokemonDetailPresenter(apiHelper: apiHelperMock, coordinator: coordinatorMock, fetchPokemonsUseCase: fetchPokemonUseCaseMock, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCaseMock, fetchFavouritesPokemonsUseCase: fetchFavouritePokemonsUseCaseMock)
        
        //When
        sut.movesButtonPushed(pokemonMoves: [], learnMethod: "")
        
        //Then
        XCTAssertEqual(coordinatorMock.goToPokemonMovesHasBeenCalled, true, "Success accessing to Pokemon Coordinator - goToPokemonMoves func.")
    }
    
    func test_Given_PokemonDetailPresenter_When_IsFavourite_Then_SetSwitchStatusFromDelegateIsCalled() {
        //Given
        let sut = DefaultPokemonDetailPresenter(apiHelper: apiHelperMock, coordinator: coordinatorMock, fetchPokemonsUseCase: fetchPokemonUseCaseMock, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCaseMock, fetchFavouritesPokemonsUseCase: fetchFavouritePokemonsUseCaseMock)
        let pokemonViewDelegate = PokemonDetailViewDelegateMock()
        //When
        sut.delegate = pokemonViewDelegate
        sut.isFavourite(pokemonId: 0)
        
        //Then
        XCTAssertEqual(pokemonViewDelegate.setSwitchStatusHasBeenCalled, true, "Success accessing to Delegate - setSwitchStatus func.")
    }
    
    func test_Given_PokemonDetailPresenter_When_GetSprites_Then_DidUpdateSpritesFromDelegateIsCalled() {
        //Given
        let sut = DefaultPokemonDetailPresenter(apiHelper: apiHelperMock, coordinator: coordinatorMock, fetchPokemonsUseCase: fetchPokemonUseCaseMock, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCaseMock, fetchFavouritesPokemonsUseCase: fetchFavouritePokemonsUseCaseMock)
        let pokemonViewDelegate = PokemonDetailViewDelegateMock()
        //When
        sut.delegate = pokemonViewDelegate
        sut.getSprites(pokemonSprites: spritesMock)
        
        //Then
        XCTAssertEqual(pokemonViewDelegate.didUpdateSpritesHasBeenCalled, true, "Success accessing to Delegate - didUpdateSprites func.")
    }
    
    func test_Given_PokemonDetailPresenter_When_GetTypesValues_Then_TypesValuesFetchedFromDelegateIsCalled() {
        //Given
        let sut = DefaultPokemonDetailPresenter(apiHelper: apiHelperMock, coordinator: coordinatorMock, fetchPokemonsUseCase: fetchPokemonUseCaseMock, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCaseMock, fetchFavouritesPokemonsUseCase: fetchFavouritePokemonsUseCaseMock)
        let pokemonViewDelegate = PokemonDetailViewDelegateMock()
        //When
        sut.delegate = pokemonViewDelegate
        sut.getTypesValues(types: ["normal"])
        
        //Then
        XCTAssertEqual(pokemonViewDelegate.typesValuesFetchedHasBeenCalled, true, "Success accessing to Delegate - typesValuesFetched func.")
    }
    
    func test_Given_PokemonDetailPresenter_When_DownloadImage_Then_ShowImageFromDelegateIsCalled() {
        //Given
        let sut = DefaultPokemonDetailPresenter(apiHelper: apiHelperMock, coordinator: coordinatorMock, fetchPokemonsUseCase: fetchPokemonUseCaseMock, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCaseMock, fetchFavouritesPokemonsUseCase: fetchFavouritePokemonsUseCaseMock)
        let pokemonViewDelegate = PokemonDetailViewDelegateMock()
        //When
        sut.delegate = pokemonViewDelegate
        sut.downloadImage(urlString: "")
        
        //Then
        XCTAssertEqual(pokemonViewDelegate.showImageHasBeenCalled, true, "Success accessing to Delegate - showImage func.")
    }
    
    func test_Given_PokemonDetailPresenter_When_GetPokemonDetail_Then_DidUpdatePokemonDetailDelegateIsCalled() {
        //Given
        let sut = DefaultPokemonDetailPresenter(apiHelper: apiHelperMock, coordinator: coordinatorMock, fetchPokemonsUseCase: fetchPokemonUseCaseMock, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCaseMock, fetchFavouritesPokemonsUseCase: fetchFavouritePokemonsUseCaseMock)
        let pokemonViewDelegate = PokemonDetailViewDelegateMock()
        //When
        sut.delegate = pokemonViewDelegate
        sut.getPokemonDetail(pokemonId: 0)
        
        //Then
        XCTAssertEqual(pokemonViewDelegate.didUpdatePokemonDetailHasBeenCalled, true, "Success accessing to Delegate - didUpdatePokemonDetail func.")
    }
    
    func test_Given_PokemonDetailPresenter_When_SwitchChanged_Then_SetFavouritePokemonDetailDelegateIsCalled() {
        //Given
        let sut = DefaultPokemonDetailPresenter(apiHelper: apiHelperMock, coordinator: coordinatorMock, fetchPokemonsUseCase: fetchPokemonUseCaseMock, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCaseMock, fetchFavouritesPokemonsUseCase: fetchFavouritePokemonsUseCaseMock)
        let pokemonViewDelegate = PokemonDetailViewDelegateMock()
        //When
        sut.delegate = pokemonViewDelegate
        sut.switchChanged(UISwitch(), pokemonDTO: pokemonMock)
        
        //Then
        XCTAssertEqual(pokemonViewDelegate.setFavouriteHasBeenCalled, true, "Success accessing to Delegate - setFavouritePokemonDetail func.")
    }
    
    func test_Given_PokemonDetailPresenter_When_ImageTapped_Then_SetSpritePositionPokemonDetailDelegateIsCalled() {
        //Given
        let sut = DefaultPokemonDetailPresenter(apiHelper: apiHelperMock, coordinator: coordinatorMock, fetchPokemonsUseCase: fetchPokemonUseCaseMock, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCaseMock, fetchFavouritesPokemonsUseCase: fetchFavouritePokemonsUseCaseMock)
        let pokemonViewDelegate = PokemonDetailViewDelegateMock()
        //When
        sut.delegate = pokemonViewDelegate
        sut.imageTapped(UITapGestureRecognizer(), sprites: ["sprite1","sprite2"], spritePosition: 1)
        
        //Then
        XCTAssertEqual(pokemonViewDelegate.setSpritePositionHasBeenCalled, true, "Success accessing to Delegate - setSpritePositionPokemonDetail func.")
    }
    
    
}
