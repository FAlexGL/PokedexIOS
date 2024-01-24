//
//  MovesListVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 13/12/23.
//

import UIKit

class MovesListVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var pokemonMoves: [PokemonMove]?
    private var presenter: MovesListPresenter
    
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
        initTable()
    }
    
    func setPokemonMoves(pokemonMoves: [PokemonMove]) {
        self.pokemonMoves = pokemonMoves
    }
    
    private func initTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
}

extension MovesListVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection(pokemonMoves: pokemonMoves)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        guard let pokemonMoves = pokemonMoves else {
            return cell
        }
        
        content.text = pokemonMoves[indexPath.row].moveName.replacingOccurrences(of: "-", with: " ")
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
        presenter.didSelectRowAt(pokemonMoves: pokemonMoves, movePosition: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
