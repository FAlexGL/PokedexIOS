//
//  PokemonListPresenterTests.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

import XCTest
import Combine
@testable import PokedexIOS

final class PokemonListPresenterTests: XCTestCase {
    
    
    var coordinator = PokemonCoordinatorMock()
    var pokemonRepositoryMock: PokemonRepositoryMock!
    var fetchPokemonUseCase: FetchPokemonUseCaseMock!
    var fetchFavouritePokemonsUseCase: FetchFavouritePokemonsUseCaseMock!
    var updateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCaseMock!
    var favouritePokemon = FavouritePokemon(pokemonId: 5, pokemonName: "MissingNo")
    
    override func setUp() {
        pokemonRepositoryMock = PokemonRepositoryMock()
        fetchPokemonUseCase = FetchPokemonUseCaseMock()
        fetchFavouritePokemonsUseCase = FetchFavouritePokemonsUseCaseMock()
        updateFavouritePokemonsUseCase = UpdateFavouritePokemonsUseCaseMock()
    }
    
    // func didSelectRowAt(showFavouritesButtonTitle: String?, indexPath: IndexPath, favouritePokemonsFetched: [FavouritePokemon])
    
    func test_Given_PokemonListPresenter_When_DidSelectedRowAtisCalledFromFavouritePokemon_Then_PokemonIdFetchedSuccessfully() {
        // Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        
        //When
        sut.didSelectRowAt(showFavouritesButtonTitle: NSLocalizedString("ShowAll", comment: ""), indexPath: IndexPath(row: 0, section: 0), favouritePokemonsFetched: [favouritePokemon])
        
        //Then
        XCTAssertEqual(coordinator.pokemonId, 5, "Pokemon's Id matches the expected")
    }
    
    func test_Given_PokemonListPresenter_When_DidSelectedRowAtisCalledFromNonFavouritePokemon_Then_PokemonIdFetchedSuccessfully() {
        // Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        
        //When
        sut.didSelectRowAt(showFavouritesButtonTitle: "", indexPath: IndexPath(row: 0, section: 0), favouritePokemonsFetched: [favouritePokemon])
        
        //Then
        XCTAssertEqual(coordinator.pokemonId, 1, "Pokemon's Id matches the expected")
    }
    
    func test_GivenPokemonListPresenter_When_favouriteButtonTapped_Then_CorrectStringReceived() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        
        //When
        let stringReceived = sut.favouriteButtonTapped(showFavouritesButtonTitle: NSLocalizedString("ShowFavourites", comment: ""))
        
        //Then
        XCTAssertEqual(stringReceived, NSLocalizedString("ShowAll", comment: ""), "Correct String received")
    }
    
    func test_Given_PokemonListPresenter_When_AddSuscribersWithThreeCharacters_Then_FetchCorrectPokemon() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        let subject = PassthroughSubject<String, Never>()
        let exp = expectation(description: "Test after 1 second")
        coordinator.goToPokemonDetailExpectation = exp
        
        //When
        sut.addSubscribers(publisher: subject.eraseToAnyPublisher())
        
        subject.send("m")
        subject.send("mi")
        subject.send("mis")
        
        let result = XCTWaiter.wait(for: [exp], timeout: 1)

        //Then
        if result == XCTWaiter.Result.timedOut {
            XCTFail("Test fail due to timeout")
        } else {
            XCTAssertEqual(coordinator.pokemonId, 1000, "Pokemon's Id matches the expected")
        }
    }
    
    func test_Given_PokemonListPresenter_When_AddSuscribersWithLessThanThreeCharacters_Then_DontMakeAnyApiCall() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        let subject = PassthroughSubject<String, Never>()
        let exp = expectation(description: "Test after 1 second")
        coordinator.goToPokemonDetailExpectation = exp
        
        //When
        sut.addSubscribers(publisher: subject.eraseToAnyPublisher())
        
        subject.send("m")
        subject.send("mi")
        
        _ = XCTWaiter.wait(for: [exp], timeout: 1)

        //Then
            XCTAssertEqual(coordinator.goToPokemonDetailHasBeenCalled, false, "Dont make API call")
    }
    
    func test_Given_PokemonListPresenter_When_AddSuscribersWithCapitalString_Then_TransformItToLowerVersion() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        let subject = PassthroughSubject<String, Never>()
        
        let exp = expectation(description: "Test after 1 second")
        coordinator.goToPokemonDetailExpectation = exp
        
        //When
        sut.addSubscribers(publisher: subject.eraseToAnyPublisher())
        
        subject.send("M")
        subject.send("MI")
        subject.send("MIS")
        subject.send("MISS")
        subject.send("MISSI")
        subject.send("MISSIN")
        subject.send("MISSING")
        subject.send("MISSINGN")
        subject.send("MISSINGNO")
        
        _ = XCTWaiter.wait(for: [exp], timeout: 1)

        //Then
        XCTAssertEqual(fetchPokemonUseCase.pokemonIdOrNameSpy, "missingno", "Dont make API call")
    }
    
    func test_Given_PokemonListPresenter_When_didSelectRowAtFromFavouritePokemonTable_Then_GetPokemonID() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        let favouritePokemon = FavouritePokemon(pokemonId: 5, pokemonName: "MissingNo")
        
        //When
        sut.didSelectRowAt(showFavouritesButtonTitle: NSLocalizedString("ShowAll", comment: ""), indexPath: IndexPath(row: 0, section: 0), favouritePokemonsFetched: [favouritePokemon])
        
        //Then
        XCTAssertEqual(coordinator.pokemonId, 5, "Success getting Pokemon's Id")
    }
    
    func test_Given_PokemonListPresenter_When_didSelectRowAtFromAllPokemonTable_Then_GetPokemonID() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        let favouritePokemon = FavouritePokemon(pokemonId: 5, pokemonName: "MissingNo")
        
        //When
        sut.didSelectRowAt(showFavouritesButtonTitle: nil, indexPath: IndexPath(row: 0, section: 0), favouritePokemonsFetched: [favouritePokemon])
        
        //Then
        XCTAssertEqual(coordinator.pokemonId, 1, "Success getting Pokemon's Id")
    }
    
    func test_Given_PokemonListPresenter_When_willDisplayisCalled_Then_GetNextURL() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        let pokemonListViewDelegate = PokemonListViewDelegateMock()
        sut.delegate = pokemonListViewDelegate
        
        //When
        sut.willDisplay(showFavouritesButtonTitle: "", totalRows: 2, indexPath: IndexPath(row: 1, section: 0), url: "www.prueba.com")
        
        //Then
        XCTAssertEqual(pokemonListViewDelegate.pokemonListDTO?.next, "www.nextURL.com", "Success getting Pokemon's Id")
    }
    
    func test_Given_PokemonListPresenter_When_numberOfRowsInSectionShowingFavouritePokemons_Then_Return_NumberOfFavouritePokemonsFetched() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        
        
        //When
        let pokemonsNumber = sut.numberOfRowsInSection(showFavouritesButtonTitle: NSLocalizedString("ShowAll", comment: ""), favouritePokemonsFetched: 5, pokemonsFetched: 100)
        
        //Then
        XCTAssertEqual(pokemonsNumber, 5, "Success getting Favourite Pokemons Number")
    }
    
    func test_Given_PokemonListPresenter_When_numberOfRowsInSectionShowingAllPokemons_Then_Return_NumberOfPokemonsFetched() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        
        
        //When
        let pokemonsNumber = sut.numberOfRowsInSection(showFavouritesButtonTitle: "", favouritePokemonsFetched: 5, pokemonsFetched: 100)
        
        //Then
        XCTAssertEqual(pokemonsNumber, 100, "Success getting All Pokemons Number")
    }
    
    func test_Given_PokemonListPresenter_When_trailingSwipeActionsConfigurationForRow_Then_CallDelegateUpdateFavouritePokemon() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        let pokemonListViewDelegate = PokemonListViewDelegateMock()
        sut.delegate = pokemonListViewDelegate
        
        //When
        sut.trailingSwipeActionsConfigurationForRowAt(pokemonId: 0, pokemonName: "MissingNo", indexPath: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssertEqual(pokemonListViewDelegate.favouriteChangedHasBeenCalled, true, "Success accessing to delegate favourite Changed func.")
    }
    
    func test_Given_PokemonListPresenter_When_favouriteButtonTappedToGetFavouritePokemons_Then_ReturnButtonString() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        let pokemonListViewDelegate = PokemonListViewDelegateMock()
        sut.delegate = pokemonListViewDelegate
        
        //When
        let buttonString = sut.favouriteButtonTapped(showFavouritesButtonTitle: NSLocalizedString("ShowFavourites", comment: ""))
        
        //Then
        XCTAssertEqual(buttonString, NSLocalizedString("ShowAll", comment: ""), "Success getting new button Title String")
        XCTAssertEqual(pokemonListViewDelegate.favouriteLoadedHasBeenCalled, true, "Success accessing to delegate favourite loaded func.")
    }
    
    func test_Given_PokemonListPresenter_When_favouriteButtonTappedToGetAllPokemons_Then_ReturnButtonString() {
        //Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: fetchPokemonUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
        
        //When
        let buttonString = sut.favouriteButtonTapped(showFavouritesButtonTitle: NSLocalizedString("ShowAll", comment: ""))
        
        //Then
        XCTAssertEqual(buttonString, NSLocalizedString("ShowFavourites", comment: ""), "Success getting new button Title String")
    }
    
}
