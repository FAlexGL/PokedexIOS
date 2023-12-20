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
    @IBOutlet weak private var favouriteSwitch: UISwitch!
    @IBOutlet weak private var hpLabel: UILabel!
    @IBOutlet weak private var attackLabel: UILabel!
    @IBOutlet weak private var deffenseLabel: UILabel!
    @IBOutlet weak private var specialAttackLabel: UILabel!
    @IBOutlet weak private var specialDefenseLabel: UILabel!
    @IBOutlet weak private var speedLabel: UILabel!
    
    //constant info views
    @IBOutlet weak private var baseExperienceCILable: UILabel!
    @IBOutlet weak private var heightCILable: UILabel!
    @IBOutlet weak private var baseStatsCILable: UILabel!
    @IBOutlet weak private var weightCILable: UILabel!
    @IBOutlet weak private var hpCILable: UILabel!
    @IBOutlet weak private var attackCILable: UILabel!
    @IBOutlet weak private var defenseCILable: UILabel!
    @IBOutlet weak private var specialAttackCILable: UILabel!
    @IBOutlet weak private var specialDefenseCILable: UILabel!
    @IBOutlet weak private var speedCILable: UILabel!
    @IBOutlet weak private var favouriteCILable: UILabel!
    @IBOutlet weak private var movesButton: UIButton!
    
    //types images
    @IBOutlet weak private var normalImage: UIImageView!
    @IBOutlet weak private var fightingImage: UIImageView!
    @IBOutlet weak private var flyingImage: UIImageView!
    @IBOutlet weak private var poisonImage: UIImageView!
    @IBOutlet weak private var groundImage: UIImageView!
    @IBOutlet weak private var rockImage: UIImageView!
    @IBOutlet weak private var bugImage: UIImageView!
    @IBOutlet weak private var ghostImage: UIImageView!
    @IBOutlet weak private var steelImage: UIImageView!
    @IBOutlet weak private var fireImage: UIImageView!
    @IBOutlet weak private var waterImage: UIImageView!
    @IBOutlet weak private var grassImage: UIImageView!
    @IBOutlet weak private var electricImage: UIImageView!
    @IBOutlet weak private var psychicImage: UIImageView!
    @IBOutlet weak private var iceImage: UIImageView!
    @IBOutlet weak private var dragonImage: UIImageView!
    @IBOutlet weak private var darkImage: UIImageView!
    @IBOutlet weak private var fairyImage: UIImageView!
    
    private var coordinator: PokemonCoordinator?
    //    private var coordinator: MovesCoordinator
    private var pokemonModel: PokemonModel?
    private let dbHelper = DBHelper.shared
    private var isFavourite: Bool?
    private var spritesArray: [String] = []
    private var spriteArrayPosition = 1
    private let defaultAlphaTypes = 0.1
    private var apiHelper = APIHelper()
    private var pokemonId: Int?
    
    var delegate: PokemonDetailDelegate?
    
    init(pokemonCoordinator: PokemonCoordinator){
        self.coordinator = pokemonCoordinator
        super.init(nibName: K.NibNames.POKEMON_DETAIL, bundle: nil)
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
            .foregroundColor: UIColor(named: K.Colours.BLUE_POKEMON_TITLE) ?? UIColor.systemBlue
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
        
        DispatchQueue.main.async { [self] in
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
            loadImage(from: pokemonModel.sprites.frontDefault)
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
    
    @IBAction private func switchChanged(_ sender: UISwitch) {
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
    
    @IBAction private func movesButtonPushed(_ sender: UIButton) {
        if let pokemonModel = self.pokemonModel, let coordinator = self.coordinator {
            DispatchQueue.main.async {
                coordinator.goToPokemonMoves(pokemonModel: pokemonModel)
            }
        }
    }
    
    @IBAction private func imageTapped(_ sender: UITapGestureRecognizer) {
        if spritesArray.count > 1 {
            loadImage(from: spritesArray[spriteArrayPosition])
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
