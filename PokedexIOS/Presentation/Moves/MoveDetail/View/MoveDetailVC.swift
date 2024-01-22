//
//  MoveDetailVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 14/12/23.
//

import UIKit

class MoveDetailVC: UIViewController {
    @IBOutlet private weak var moveNameLabel: UILabel!
    @IBOutlet private weak var imageMoveClass: UIImageView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var targetLabel: UILabel!
    @IBOutlet private weak var powerLabel: UILabel!
    @IBOutlet private weak var ppLabel: UILabel!
    @IBOutlet private weak var priorityLabel: UILabel!
    @IBOutlet private weak var accuracyLabel: UILabel!
    @IBOutlet weak var imageMoveType: UIImageView!
    @IBOutlet weak var levelGamesTextView: UITextView!
    
    //constant info views
    @IBOutlet private weak var descriptionCILable: UILabel!
    @IBOutlet private weak var targetCILable: UILabel!
    @IBOutlet private weak var powerCILable: UILabel!
    @IBOutlet private weak var ppCILable: UILabel!
    @IBOutlet private weak var priorityCILable: UILabel!
    @IBOutlet private weak var accuracyCILable: UILabel!
    @IBOutlet private weak var learnedAtCILable: UILabel!
    
    private var moveModel: MoveModel?
    private var levelsMove: PokemonModel.Move?
    private var effectChance = 0
    private var moveName: String?
    private var presenter: MoveDetailPresenter
    
    init(presenter: MoveDetailPresenter){
        self.presenter = presenter
        super.init(nibName: Constants.NibNames.POKEMON_MOVE_DETAIL, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegates()
        translateViews()
        getMoveDetail()
    }
    
    func initDelegates() {
        presenter.delegate = self
    }
    
    func setMoves(moveName: String, levelsMove: PokemonModel.Move){
        self.moveName = moveName
        self.levelsMove = levelsMove
    }
    
    private func getMoveDetail(){
        presenter.getMoveDetail(moveName: moveName)
    }
    
    private func translateViews(){
        let descriptionString = NSLocalizedString("Description", comment: "")
        let targetString = NSLocalizedString("Target", comment: "")
        let powerString = NSLocalizedString("Power", comment: "")
        let priorityString = NSLocalizedString("Priority", comment: "")
        let accuracyString = NSLocalizedString("Accuracy", comment: "")
        let learnedAtString = NSLocalizedString("LearnedAt", comment: "")
        
        descriptionCILable.text = descriptionString
        targetCILable.text = targetString
        powerCILable.text = powerString
        priorityCILable.text = priorityString
        accuracyCILable.text = accuracyString
        learnedAtCILable.text = learnedAtString
    }
    
    private func showData(moveModel: MoveModel){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            presenter.showData(moveModel: moveModel, levelsMove: levelsMove)
        }
    }
}

extension MoveDetailVC: MoveDetailViewDelegate {
    func showData(moveData: [String : String], levelGames: NSMutableAttributedString) {
        self.moveNameLabel.text = moveData["name"]
        self.imageMoveClass.image = UIImage(named: moveData["damageClass"] ?? "")
        self.imageMoveType.image = UIImage(named: moveData["moveType"] ?? "")
        self.descriptionTextView.text = moveData["description"]
        self.targetLabel.text = moveData["target"]
        self.powerLabel.text = moveData["power"]
        self.ppLabel.text = moveData["pp"]
        self.priorityLabel.text = moveData["priority"]
        self.accuracyLabel.text = moveData["accuracy"]
        self.levelGamesTextView.attributedText = levelGames
    }
    
    func didUpdatePokemonMove(moveModel: MoveModel) {
        showData(moveModel: moveModel)
    }
}
