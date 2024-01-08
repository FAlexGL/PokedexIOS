//
//  PokemonCellVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import UIKit

class PokemonCellVC: UITableViewCell {

    @IBOutlet weak private var pokemonName: UILabel!
    @IBOutlet weak private var pokemonID: UILabel!
    @IBOutlet weak private var pokemonImage: UIImageView!
    @IBOutlet weak private var contentCellView: UIView!
    
    @IBOutlet weak var favouriteImage: UIImageView!
    
    private let dbHelper = DBHelper.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentCellView.layer.cornerRadius = 15
    }
    
    func showData(pokemonID: Int, pokemonName: String) {
        self.pokemonID.text = "#\(pokemonID)"
        self.pokemonName.text = pokemonName
        let urlString = "\(K.PokemonAPI.URL_POKEMON_IMAGE)\(pokemonID).png"
        loadImage(from: urlString)
        favouriteImage.isHidden = dbHelper.isFavourite(pokemonId: pokemonID) ? false : true
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Error converting URL object")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error obtaining pokemon's sprite: \(error)")
                self.pokemonImage.image = UIImage(named: K.Images.MISSINGNO)
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
}
