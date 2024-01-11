//
//  MovesListVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 13/12/23.
//

import UIKit

class MovesListVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var pokemonModel: PokemonModel?
    private var apiHelper: APIHelper = DefaultAPIHelper.share
    private var presenter: MovesListPresenter
//    private var coordinator: MovesCoordinator
    
//    init(coordinator: MovesCoordinator){
//        self.coordinator = coordinator
//        super.init(nibName: Constants.NibNames.POKEMON_MOVES_LIST, bundle: nil)
//    }
    
    init(presenter: MovesListPresenter){
        self.presenter = presenter
        super.init(nibName: Constants.NibNames.POKEMON_MOVES_LIST, bundle: nil)
    }
    
    @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiHelper.delegate = self
        initTable()
    }
    
    func setPokemonModel(pokemonModel: PokemonModel) {
        self.pokemonModel = pokemonModel
    }
    
    private func initTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
}

extension MovesListVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let pokemonModel = self.pokemonModel{
            return pokemonModel.moves.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = pokemonModel?.moves[indexPath.row].moveName.replacingOccurrences(of: "-", with: " ")
        content.textProperties.font = UIFont.systemFont(ofSize: 20)
        content.textProperties.color = UIColor(named: Constants.Colours.YELLOW_POKEMON_TITLE) ?? UIColor.yellow
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor(named: Constants.Colours.BLUE_POKEMON_TITLE)
        return cell
    }
}

extension MovesListVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pokemonModel = self.pokemonModel {
//            coordinator.goToMoveDetail(moveName: pokemonModel.moves[indexPath.row].moveName, levelsMove: pokemonModel.moves[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MovesListVC: APIHelperDelegate{
    func didFailWithError(error: Error) {
        print("Error: \(error)")
    }
}
