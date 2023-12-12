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
    
    var delegate: PokemonDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor.systemBlue
        ]
    }
    
    func showData(pokemonModel: PokemonModel){
        print("Accesing to \(pokemonModel.pokemonName)'s data...")
        self.pokemonModel = pokemonModel
        DispatchQueue.main.async { [self] in
            self.title = "#\(pokemonModel.pokemonId) \(pokemonModel.pokemonName)"
            self.heightLabel.text = "Height: \(pokemonModel.height)"
            weightLabel.text = "Weight: \(pokemonModel.weight)"
            if pokemonModel.baseExperience != -1 {
                baseExperienceLabel.text = "Base experience: \(pokemonModel.baseExperience)"
            } else {
                baseExperienceLabel.text = ""
            }
            var types = "Types: "
            for i in 0..<pokemonModel.types.count {
                if i != pokemonModel.types.count-1{
                    types.append("\(pokemonModel.types[i]), ")
                } else {
                    types.append("\(pokemonModel.types[i]).")
                }
            }
            typesLabel.text = types
            var stats = ""
            for stat in pokemonModel.stats {
                stats.append("\(stat.nameStat): \(stat.baseStat)\n")
            }
            statsTextView.text = stats
            if dbHelper.isFavourite(pokemonId: pokemonModel.pokemonId){
                favouriteSwitch.isOn = true
            }
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
                delegate?.favouriteUpdated(pokemonID: pokemonModel.pokemonId, isFavourite: true)
            } else {
                dbHelper.deleteFavourite(pokemonId: pokemonModel.pokemonId)
                delegate?.favouriteUpdated(pokemonID: pokemonModel.pokemonId, isFavourite: false)
            }
        }
    }
}
