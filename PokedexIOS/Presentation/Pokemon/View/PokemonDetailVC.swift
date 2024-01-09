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
    
    @IBOutlet private weak var pokemonImage: UIImageView!
    @IBOutlet private weak var heightLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var baseExperienceLabel: UILabel!
    @IBOutlet private weak var favouriteSwitch: UISwitch!
    @IBOutlet private weak var hpLabel: UILabel!
    @IBOutlet private weak var attackLabel: UILabel!
    @IBOutlet private weak var deffenseLabel: UILabel!
    @IBOutlet private weak var specialAttackLabel: UILabel!
    @IBOutlet private weak var specialDefenseLabel: UILabel!
    @IBOutlet private weak var speedLabel: UILabel!
    
    //constant info views
    @IBOutlet private weak var baseExperienceCILable: UILabel!
    @IBOutlet private weak var heightCILable: UILabel!
    @IBOutlet private weak var baseStatsCILable: UILabel!
    @IBOutlet private weak var weightCILable: UILabel!
    @IBOutlet private weak var hpCILable: UILabel!
    @IBOutlet private weak var attackCILable: UILabel!
    @IBOutlet private weak var defenseCILable: UILabel!
    @IBOutlet private weak var specialAttackCILable: UILabel!
    @IBOutlet private weak var specialDefenseCILable: UILabel!
    @IBOutlet private weak var speedCILable: UILabel!
    @IBOutlet private weak var favouriteCILable: UILabel!
    @IBOutlet private weak var movesButton: UIButton!
    
    //types images
    @IBOutlet private weak var normalImage: UIImageView!
    @IBOutlet private weak var fightingImage: UIImageView!
    @IBOutlet private weak var flyingImage: UIImageView!
    @IBOutlet private weak var poisonImage: UIImageView!
    @IBOutlet private weak var groundImage: UIImageView!
    @IBOutlet private weak var rockImage: UIImageView!
    @IBOutlet private weak var bugImage: UIImageView!
    @IBOutlet private weak var ghostImage: UIImageView!
    @IBOutlet private weak var steelImage: UIImageView!
    @IBOutlet private weak var fireImage: UIImageView!
    @IBOutlet private weak var waterImage: UIImageView!
    @IBOutlet private weak var grassImage: UIImageView!
    @IBOutlet private weak var electricImage: UIImageView!
    @IBOutlet private weak var psychicImage: UIImageView!
    @IBOutlet private weak var iceImage: UIImageView!
    @IBOutlet private weak var dragonImage: UIImageView!
    @IBOutlet private weak var darkImage: UIImageView!
    @IBOutlet private weak var fairyImage: UIImageView!
    
    private var coordinator: PokemonCoordinator?
    private var pokemonModel: PokemonModel?
    private let dbHelper: DBHelper = DefaultDBHelper.shared
    private var apiHelper: APIHelper = DefaultAPIHelper.share
    private var isFavourite: Bool?
    private var spritesArray: [String] = []
    private var spriteArrayPosition = 1
    private let defaultAlphaTypes = 0.1
    private var pokemonId: Int?
    
    var delegate: PokemonDetailDelegate?
    
    init(pokemonCoordinator: PokemonCoordinator){
        self.coordinator = pokemonCoordinator
        super.init(nibName: Constants.NibNames.POKEMON_DETAIL, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiHelper.delegate = self
        translateViews()
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor(named: Constants.Colours.BLUE_POKEMON_TITLE) ?? UIColor.systemBlue
        ]
        getPokemonDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let isFavourite = isFavourite, let pokemonId = pokemonModel?.pokemonId, isMovingFromParent{
            delegate?.favouriteUpdated(pokemonID: pokemonId, isFavourite: isFavourite)
        }
    }
    
    
    func setPokemonId(pokemonId: Int){
        self.pokemonId = pokemonId
    }
    
    private func getPokemonDetail(){
        if let pokemonId = pokemonId{
            apiHelper.fetchPokemonDetail(pokemonId: pokemonId)
        }
    }
    
    private func translateViews(){
        let baseExperienceString = NSLocalizedString("BaseExperience", comment: "")
        let heightString = NSLocalizedString("Height", comment: "")
        let baseStatsString = NSLocalizedString("BaseStats", comment: "")
        let weightSring = NSLocalizedString("Weight", comment: "")
        let attackString = NSLocalizedString("Attack", comment: "")
        let defenseString = NSLocalizedString("Deffense", comment: "")
        let specialAttackString = NSLocalizedString("SpecialAttack", comment: "")
        let specialDefenseString = NSLocalizedString("SpecialDefense", comment: "")
        let speedString = NSLocalizedString("Speed", comment: "")
        let movesString = NSLocalizedString("Moves", comment: "")
        let favouriteString = NSLocalizedString("Favourite", comment: "")
        
        baseExperienceCILable.text = baseExperienceString
        heightCILable.text = heightString
        baseStatsCILable.text = baseStatsString
        weightCILable.text = weightSring
        attackCILable.text = attackString
        defenseCILable.text = defenseString
        specialAttackCILable.text = specialAttackString
        specialDefenseCILable.text = specialDefenseString
        speedCILable.text = speedString
        movesButton.setTitle(movesString, for: .normal)
        favouriteCILable.text = favouriteString
        
    }
    
    private func showData(pokemonModel: PokemonModel){
        print("Accesing to \(pokemonModel.pokemonName)'s data...")
        spritesArray = []
        spriteArrayPosition = 1
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.pokemonModel = pokemonModel
            self.title = "#\(pokemonModel.pokemonId) \((pokemonModel.pokemonName).uppercased())"
            self.heightLabel.text = "\(pokemonModel.height)"
            weightLabel.text = "\(pokemonModel.weight)"
            baseExperienceLabel.text = pokemonModel.baseExperience != -1 ? "\(pokemonModel.baseExperience)" : ""
            for stat in pokemonModel.stats{
                switch stat.statName {
                case "hp":
                    hpLabel.text = "\(stat.baseStat)"
                case "attack":
                    attackLabel.text = "\(stat.baseStat)"
                case "defense":
                    deffenseLabel.text = "\(stat.baseStat)"
                case "special-attack":
                    specialAttackLabel.text = "\(stat.baseStat)"
                case "special-defense":
                    specialDefenseLabel.text = "\(stat.baseStat)"
                case "speed":
                    speedLabel.text = "\(stat.baseStat)"
                default:
                    print("Unknow stat: \(stat.statName) - \(stat.baseStat)")
                }
            }
            favouriteSwitch.isOn = dbHelper.isFavourite(pokemonId: pokemonModel.pokemonId) ? true : false
            apiHelper.downloadImage(from: pokemonModel.sprites.frontDefault) { [weak self] (image) in
                guard let self = self else {return}
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let image = image {
                        self.pokemonImage.image = image
                    } else {
                        self.pokemonImage.image = UIImage(named: Constants.Images.MISSINGNO)
                    }
                }
            }
            showTypes(types: pokemonModel.types)
        }
        getSprites(pokemonModel.sprites)
        print("Total sprites: \(spritesArray.count)")
    }
    
    private func showTypes(types: [String]) {
        normalImage.alpha = defaultAlphaTypes
        fightingImage.alpha = defaultAlphaTypes
        flyingImage.alpha = defaultAlphaTypes
        poisonImage.alpha = defaultAlphaTypes
        groundImage.alpha = defaultAlphaTypes
        rockImage.alpha = defaultAlphaTypes
        bugImage.alpha = defaultAlphaTypes
        ghostImage.alpha = defaultAlphaTypes
        steelImage.alpha = defaultAlphaTypes
        fireImage.alpha = defaultAlphaTypes
        waterImage.alpha = defaultAlphaTypes
        grassImage.alpha = defaultAlphaTypes
        electricImage.alpha = defaultAlphaTypes
        psychicImage.alpha = defaultAlphaTypes
        iceImage.alpha = defaultAlphaTypes
        dragonImage.alpha = defaultAlphaTypes
        darkImage.alpha = defaultAlphaTypes
        fairyImage.alpha = defaultAlphaTypes
        
        for type in types {
            switch type {
            case "normal":
                normalImage.alpha = 1.0
            case "fighting":
                fightingImage.alpha = 1.0
            case "flying":
                flyingImage.alpha = 1.0
            case "poison":
                poisonImage.alpha = 1.0
            case "ground":
                groundImage.alpha = 1.0
            case "rock":
                rockImage.alpha = 1.0
            case "bug":
                bugImage.alpha = 1.0
            case "ghost":
                ghostImage.alpha = 1.0
            case "steel":
                steelImage.alpha = 1.0
            case "fire":
                fireImage.alpha = 1.0
            case "water":
                waterImage.alpha = 1.0
            case "grass":
                grassImage.alpha = 1.0
            case "electric":
                electricImage.alpha = 1.0
            case "psychic":
                psychicImage.alpha = 1.0
            case "ice":
                iceImage.alpha = 1.0
            case "dragon":
                dragonImage.alpha = 1.0
            case "dark":
                darkImage.alpha = 1.0
            case "fairy":
                fairyImage.alpha = 1.0
            default:
                print("error con el typo: \(type)")
            }
        }
    }
    
    
    private func getSprites(_ sprites: PokemonModel.Sprites){
        spritesArray.append(sprites.frontDefault)
        if let backDefault = sprites.backDefault {
            spritesArray.append(backDefault)
        }
        if let backFemale = sprites.backFemale {
            spritesArray.append(backFemale)
        }
        if let backShiny = sprites.backShiny {
            spritesArray.append(backShiny)
        }
        if let backShinyFemale = sprites.backShinyFemale{
            spritesArray.append(backShinyFemale)
        }
        if let frontFemale = sprites.frontFemale {
            spritesArray.append(frontFemale)
        }
        if let frontShiny = sprites.frontShiny {
            spritesArray.append(frontShiny)
        }
        if let frontShinyFemale = sprites.frontShinyFemale {
            spritesArray.append(frontShinyFemale)
        }
        if let officialFront = sprites.officialFront{
            spritesArray.append(officialFront)
        }
        if let officialFrontShiny = sprites.officialFrontShiny {
            spritesArray.append(officialFrontShiny)
        }
    }
    
    @IBAction private func switchChanged(_ sender: UISwitch) {
        if let pokemonModel = self.pokemonModel {
            // Control error
            if sender.isOn{
                let favouritePokemon = FavouritePokemon(pokemonId: pokemonModel.pokemonId, pokemonName: pokemonModel.pokemonName)
                _ = dbHelper.saveFavourite(favouritePokemon: favouritePokemon)
            } else {
                _ = dbHelper.deleteFavourite(pokemonId: pokemonModel.pokemonId)
            }
            self.isFavourite = sender.isOn
        }
    }
    
    @IBAction private func movesButtonPushed(_ sender: UIButton) {
        if let pokemonModel = self.pokemonModel, let coordinator = self.coordinator {
            DispatchQueue.main.async {
                coordinator.goToPokemonMoves(pokemonModel: pokemonModel)
            }
        }
    }
    
    @IBAction private func imageTapped(_ sender: UITapGestureRecognizer) {
        if spritesArray.count > 1 {
            apiHelper.downloadImage(from: spritesArray[spriteArrayPosition]) { image in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let image = image {
                        self.pokemonImage.image = image
                    } else {
                        self.pokemonImage.image = UIImage(named: Constants.Images.MISSINGNO)
                    }
                }
            }
            if spriteArrayPosition < spritesArray.count-1{
                spriteArrayPosition += 1
            } else {
                spriteArrayPosition = 0
            }
        }
    }
}

extension PokemonDetailVC: APIHelperDelegate{
    func didFailWithError(error: Error) {
        print("error: \(error)")
    }
    
    func didUpdatePokemonDetail(pokemonModel: PokemonModel) {
        showData(pokemonModel: pokemonModel)
    }
}
