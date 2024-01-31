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
    private var pokemonDTO: PokemonRepresentable?
    private var isFavourite: Bool?
    private var learnMethod: String?
    private var spritesArray: [String] = []
    private var spriteArrayPosition: Int = -1
    private let defaultAlphaTypes = 0.1
    private var pokemonId: Int?
    private var presenter: PokemonDetailPresenter
    
    var delegate: PokemonDetailDelegate?
    
    init(presenter: PokemonDetailPresenter){
        self.presenter = presenter
        super.init(nibName: Constants.NibNames.POKEMON_DETAIL, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegates()
        translateViews()
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor(named: Constants.Colours.BLUE_POKEMON_TITLE) ?? UIColor.systemBlue
        ]
        getPokemonDetail()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let isFavourite = isFavourite, let pokemonId = pokemonDTO?.id, isMovingFromParent {
            delegate?.favouriteUpdated(pokemonID: pokemonId, isFavourite: isFavourite)
        }
    }
    
    func setPokemonId(pokemonId: Int){
        self.pokemonId = pokemonId
    }
    
    private func initDelegates(){
        presenter.delegate = self
    }
    
    private func getPokemonDetail(){
        if let pokemonId = pokemonId{
            presenter.getPokemonDetail(pokemonId: pokemonId)
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
    
    private func getStats(pokemonDTO: PokemonRepresentable) -> [(statName: String, baseStat: Int)]{
        var stats: [(statName: String, baseStat: Int)] = []
        for stat in pokemonDTO.statsRepresentable {
            let stat = (statName: stat.statRepresentable.name, baseStat: stat.baseStat)
            stats.append(stat)
        }
        return stats
    }
    
    private func getTypes(pokemonDTO: PokemonRepresentable) -> [String] {
        var types: [String] = []
        for type in pokemonDTO.typesRepresentable {
            types.append(type.typeRepresentable.name)
        }
        return types
    }
    
    private func showData(pokemonDTO: PokemonRepresentable){
        print("Accesing to \(pokemonDTO.name)'s data...")
        spriteArrayPosition = 1
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.pokemonDTO = pokemonDTO
            self.title = "#\(pokemonDTO.id) \((pokemonDTO.name).uppercased())"
            self.heightLabel.text = "\(pokemonDTO.height)"
            weightLabel.text = "\(pokemonDTO.weight)"
            var baseExperience = ""
            if pokemonDTO.baseExperience != nil {
                baseExperience = "\(pokemonDTO.baseExperience!)"
            }
            baseExperienceLabel.text = baseExperience
            for stat in getStats(pokemonDTO: pokemonDTO){
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
            presenter.isFavourite(pokemonId: pokemonDTO.id)
            presenter.downloadImage(urlString: pokemonDTO.spritesRepresentable.frontDefault)
            presenter.getTypesValues(types: getTypes(pokemonDTO: pokemonDTO))
        }
        presenter.getSprites(pokemonSprites: pokemonDTO.spritesRepresentable)
        print("Total sprites: \(spritesArray.count)")
    }
    
    private func getLevelMoves(pokemonDTO: PokemonRepresentable) -> [PokemonMove] {
        guard let learnMethod = learnMethod else {
            return []
        }
        
        let moves = pokemonDTO.movesRepresentable
        var pokemonMoves: [PokemonMove] = []
        for move in moves {
            let moveName = move.moveRepresentable.name
            let moveURL = move.moveRepresentable.url
            var moveVersionDetails: [(level: Int, game: String)] = []
            for moveVersion in move.versionGroupDetailsRepresentable {
                if moveVersion.moveLearnMethodRepresentable.name == learnMethod {
                    moveVersionDetails.append((level: moveVersion.levelLearnedAt, game: moveVersion.versionGroupRepresentable.name))
                }
            }
            if moveVersionDetails.count > 0 {
                let pokemonMove = PokemonMove(moveName: moveName, moveURL: moveURL, moves: [learnMethod : moveVersionDetails])
                pokemonMoves.append(pokemonMove)
            }
        }
        return pokemonMoves
    }
    
    @IBAction private func switchChanged(_ sender: UISwitch) {
        presenter.switchChanged(sender, pokemonDTO: pokemonDTO)
    }
    
    @IBAction private func movesButtonPushed(_ sender: UIButton) {
        guard let pokemonDTO = pokemonDTO else {
            return
        }
        learnMethod = Constants.MoveLearnMethods.LEVEL_METHOD // Injecting learn method (hard-coding)
        let pokemonMoves = getLevelMoves(pokemonDTO: pokemonDTO)
        if let learnMethod = learnMethod, pokemonMoves.count > 0 {
            DispatchQueue.main.async {
                self.presenter.movesButtonPushed(pokemonMoves: pokemonMoves, learnMethod: learnMethod)
            }
        }
    }
    
    @IBAction private func imageTapped(_ sender: UITapGestureRecognizer) {
        presenter.imageTapped(sender, sprites: spritesArray, spritePosition: spriteArrayPosition)
    }
}

extension PokemonDetailVC: PokemonDetailViewDelegate {
    
    func setSpritePosition(spritePosition: Int) {
        spriteArrayPosition = spritePosition
    }
    
    
    func setFavourite(isFavourite: Bool) {
        self.isFavourite = isFavourite
    }
    
    func typesValuesFetched(types: [String : Double]) {
        normalImage.alpha = types["normal"] ?? 0.1
        fightingImage.alpha = types["fighting"] ?? 0.1
        flyingImage.alpha = types["flying"] ?? 0.1
        poisonImage.alpha = types["poison"] ?? 0.1
        groundImage.alpha = types["ground"] ?? 0.1
        rockImage.alpha = types["rock"] ?? 0.1
        bugImage.alpha = types["bug"] ?? 0.1
        ghostImage.alpha = types["ghost"] ?? 0.1
        steelImage.alpha = types["steel"] ?? 0.1
        fireImage.alpha = types["fire"] ?? 0.1
        waterImage.alpha = types["water"] ?? 0.1
        grassImage.alpha = types["grass"] ?? 0.1
        electricImage.alpha = types["electric"] ?? 0.1
        psychicImage.alpha = types["psychic"] ?? 0.1
        iceImage.alpha = types["ice"] ?? 0.1
        dragonImage.alpha = types["dragon"] ?? 0.1
        darkImage.alpha = types["dark"] ?? 0.1
        fairyImage.alpha = types["fairy"] ?? 0.1
    }
    
    func didUpdateSprites(spritesArray: [String]) {
        self.spritesArray = spritesArray
    }
    
    
    func didUpdatePokemonDetail(pokemonDTO: PokemonRepresentable) {
        showData(pokemonDTO: pokemonDTO)
    }
    
    func didFailWithError(error: Error) {
        print("error: \(error)")
    }
    
    func showImage(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.pokemonImage.image = image
        }
    }
    
    func setSwitchStatus(switchStatus: Bool) {
        favouriteSwitch.isOn = switchStatus
    }
    
}
