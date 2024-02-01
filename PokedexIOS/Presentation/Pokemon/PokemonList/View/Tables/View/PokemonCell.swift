//
//  PokemonCell.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import UIKit
import Combine


//
class PokemonCell: UITableViewCell {
    
    @IBOutlet private weak var pokemonName: UILabel!
    @IBOutlet private weak var pokemonID: UILabel!
    @IBOutlet private weak var pokemonImage: UIImageView!
    @IBOutlet private weak var contentCellView: UIView!
    
    @IBOutlet weak var favouriteImage: UIImageView!
    
    private let dbHelper:  DBHelper = DefaultDBHelper.shared
    private let apiHelper: APIHelper = DefaultAPIHelper.shared
    private var subscriptions: Set<AnyCancellable> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentCellView.layer.cornerRadius = 15
    }
    
    func showData(pokemonID: Int, pokemonName: String) {
        self.pokemonID.text = "#\(pokemonID)"
        self.pokemonName.text = pokemonName
        let urlString = "\(Constants.PokemonAPI.URL_POKEMON_IMAGE)\(pokemonID).png"
        favouriteImage.isHidden = dbHelper.isFavourite(pokemonId: pokemonID) ? false : true
        apiHelper.downloadImage(from: urlString)
            .sink(receiveValue: { image in
                DispatchQueue.main.async {
                    self.pokemonImage.image = image
                }
            })
            .store(in: &subscriptions)
    }
}

extension PokemonCell: PokemonCellViewDelegate {
    func didFetchImage(image: UIImage) {
        //
    }
    
    
}
