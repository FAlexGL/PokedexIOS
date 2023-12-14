//
//  PokemonDetailVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import UIKit

protocol PokemonDetailDelegate {
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool)
}

class PokemonDetailVC: UIViewController {
    @IBOutlet weak private var pokemonImage: UIImageView!
    @IBOutlet weak private var heightLabel: UILabel!
    @IBOutlet weak private var weightLabel: UILabel!
    @IBOutlet weak private var baseExperienceLabel: UILabel!
    @IBOutlet weak private var typesLabel: UILabel!
    @IBOutlet weak private var statsTextView: UITextView!
    @IBOutlet weak private var favouriteSwitch: UISwitch!
    
    private var pokemonModel: PokemonModel?
    private let dbHelper = DBHelper.shared
    private var isFavourite: Bool?
    
    var delegate: PokemonDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor.systemBlue
        ]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let isFavourite = isFavourite, let pokemonId = pokemonModel?.pokemonId, isMovingFromParent{
            delegate?.favouriteUpdated(pokemonID: pokemonId, isFavourite: isFavourite)
        }
    }
    
    func showData(pokemonModel: PokemonModel){
        print("Accesing to \(pokemonModel.pokemonName)'s data...")
        self.pokemonModel = pokemonModel
        DispatchQueue.main.async { [self] in
            self.title = "#\(pokemonModel.pokemonId) \((pokemonModel.pokemonName).uppercased())"
            self.heightLabel.text = "Height: \(pokemonModel.height)"
            weightLabel.text = "Weight: \(pokemonModel.weight)"
            baseExperienceLabel.text = pokemonModel.baseExperience != -1 ? "Base experience: \(pokemonModel.baseExperience)" : ""
            var types = "Types: "
            for i in 0..<pokemonModel.types.count {
                i != pokemonModel.types.count-1 ? types.append("\(pokemonModel.types[i]), ") : types.append("\(pokemonModel.types[i]).")
            }
            typesLabel.text = types
            var stats = ""
            for stat in pokemonModel.stats {
                stats.append("\(stat.nameStat): \(stat.baseStat)\n")
            }
            statsTextView.text = stats
            favouriteSwitch.isOn = dbHelper.isFavourite(pokemonId: pokemonModel.pokemonId) ? true : false
            loadImage(from: pokemonModel.spriteURL)
        }
        
    }
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Error converting URL object")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error obtaining pokemon's sprite: \(error)")
            }
            if let data = data {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data){
                        self.pokemonImage.image = image
                    }
                }
            }
        }
        task.resume()
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if let pokemonModel = self.pokemonModel {
            if sender.isOn{
                let favouritePokemon = FavouritePokemon(pokemonId: pokemonModel.pokemonId, pokemonName: pokemonModel.pokemonName)
                dbHelper.saveFavourite(favouritePokemon: favouritePokemon)
            } else {
                dbHelper.deleteFavourite(pokemonId: pokemonModel.pokemonId)
            }
            self.isFavourite = sender.isOn
        }
    }
    
    @IBAction func movesButtonPushed(_ sender: UIButton) {
        let movesListVC = MovesListVC(nibName: K.NibNames.POKEMON_MOVES_LIST, bundle: nil)
        if let pokemonModel = self.pokemonModel {
            DispatchQueue.main.async {
                movesListVC.showData(pokemonModel: pokemonModel)
                self.navigationController?.pushViewController(movesListVC, animated: true)
            }
        }
    }
}
