//
//  PokemonCell.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import UIKit


//
class PokemonCell: UITableViewCell {

    @IBOutlet private weak var pokemonName: UILabel!
    @IBOutlet private weak var pokemonID: UILabel!
    @IBOutlet private weak var pokemonImage: UIImageView!
    @IBOutlet private weak var contentCellView: UIView!
    
    @IBOutlet weak var favouriteImage: UIImageView!
    
    private let dbHelper: DBHelper = DefaultDBHelper.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentCellView.layer.cornerRadius = 15
    }
    
    func showData(pokemonID: Int, pokemonName: String) {
        self.pokemonID.text = "#\(pokemonID)"
        self.pokemonName.text = pokemonName
        let urlString = "\(Constants.PokemonAPI.URL_POKEMON_IMAGE)\(pokemonID).png"
        loadImage(from: urlString)
        favouriteImage.isHidden = dbHelper.isFavourite(pokemonId: pokemonID) ? false : true
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Error converting URL object")
            return
        }
        // Move to APIHelper
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error obtaining pokemon's sprite: \(error)")
                self.pokemonImage.image = UIImage(named: Constants.Images.MISSINGNO)
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
