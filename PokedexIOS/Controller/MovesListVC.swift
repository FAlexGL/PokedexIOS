//
//  MovesListVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 13/12/23.
//

import UIKit

class MovesListVC: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    
    private var pokemonModel: PokemonModel?
    private var apiHelper = APIHelper.share
    private var selectedRow: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiHelper.delegate = self
        initTable()
    }
    
    func initTable(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    
    func setPokemonModel(pokemonModel: PokemonModel){
        self.pokemonModel = pokemonModel
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
        content.textProperties.color = UIColor(named: K.Colours.YELLOW_POKEMON_TITLE) ?? UIColor.yellow
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor(named: K.Colours.BLUE_POKEMON_TITLE)
        return cell
    }
}

extension MovesListVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pokemonModel = self.pokemonModel {
            let moveDetailVC = MoveDetailVC(nibName: K.NibNames.POKEMON_MOVE_DETAIL, bundle: nil)
            moveDetailVC.setMoves(moveName: pokemonModel.moves[indexPath.row].moveName, levelsMove: pokemonModel.moves[indexPath.row])
            print(pokemonModel.moves[indexPath.row].moveName)
            self.selectedRow = indexPath.row
            self.navigationController?.pushViewController(moveDetailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MovesListVC: APIHelperDelegate{
    func didFailWithError(error: Error) {
        print("Error: \(error)")
    }
}
