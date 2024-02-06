//
//  PokemonListVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import UIKit
import Combine

class PokemonListVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var pokemons: [PokemonRepresentable] = []
    private var pokemonListDTO: PokemonListRepresentable?
    private var url = Constants.PokemonAPI.URL_POKEMON_LIST
    private var positionOfFavouritePokemonSelected: IndexPath?
    private var presenter: PokemonListPresenter
    private var subscriptions = Set<AnyCancellable>()

    init(presenter: PokemonListPresenter){
        self.presenter = presenter
        super.init(nibName: Constants.NibNames.POKEMON_LIST, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        addSubscribers()
        initTable()
        initNavigationControllerFavouriteButton()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavController()
    }
    
    private func setNavController(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: Constants.Colours.BLUE_POKEMON_TITLE)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func initNavigationControllerFavouriteButton(){
        let buttonFavourites = UIButton(type: .system)
        buttonFavourites.tintColor = UIColor.white
        let buttonString = NSLocalizedString("ShowFavourites", comment: "")
        buttonFavourites.setTitle(buttonString, for: .normal)
        buttonFavourites.addTarget(self, action: #selector(favouriteButtonTapped(_:)), for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: buttonFavourites)
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    private func initTable(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 93.0
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: Constants.Identifiers.POKEMON_CELL_IDENTIFIER)
    }
    
    private func addSubscribers() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
            .map { ($0.object as? UISearchTextField)?.text ?? "" }
            .eraseToAnyPublisher()
        
        presenter.addSubscribers(publisher: publisher)        
    }
    
    @objc private func favouriteButtonTapped(_ sender: UIButton!){
        let buttonString = presenter.favouriteButtonTapped()
        self.navigationItem.rightBarButtonItem?.title = buttonString
        sender.setTitle(buttonString, for: .normal)
    }
}


extension PokemonListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.POKEMON_CELL_IDENTIFIER, for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }
        let model = pokemons[indexPath.row]
        cell.showData(pokemonID: model.id, pokemonName: model.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stringFavourite = NSLocalizedString("Favourite", comment: "")
        let item = UIContextualAction(style: .normal, title: stringFavourite) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.presenter.trailingSwipeActionsConfigurationForRowAt(pokemon: pokemons[indexPath.row], indexPath: indexPath)
            completionHandler(true)
        }
        item.image = UIImage(named: Constants.Images.POKEBALL_FAVOURITE)
        item.backgroundColor = UIColor(named: Constants.Colours.BLUE_POKEMON_TITLE)
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
}

extension PokemonListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplay(totalRows: pokemons.count, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(pokemon: pokemons[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension PokemonListVC {
    func bind() {
        bindPokemonsList()
        bindFavoriteChanged()
        bindError()
    }
    
    func bindPokemonsList() {
        presenter.statePublisher
            .sink { [weak self] in
                switch $0 {
                case .reloadTable(let pokemons):
                    self?.pokemons = pokemons.sorted { $0.id < $1.id }
                    self?.tableView.reloadData()
                default: break
                }
            }.store(in: &subscriptions)
    }
    
    func bindFavoriteChanged() {
        presenter.statePublisher
            .sink { [weak self] in
                switch $0 {
                case .favoriteChanged(let indexPath):
                    self?.favouriteChanged(indexPath: indexPath)
                default: break
                }
            }.store(in: &subscriptions)
    }
    
    func bindError() {
        presenter.statePublisher
            .sink { [weak self] in
                switch $0 {
                case .showError(let errorMessage):
                    self?.showErrorAlert(errorMessage: errorMessage)
                default: break
                }
            }.store(in: &subscriptions)
    }
}

private extension PokemonListVC {
    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .actionSheet)
        self.present(alert , animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true)
        }
    }
    
    func favouriteChanged(indexPath: IndexPath) {
        tableView.reloadData()
    }

}
