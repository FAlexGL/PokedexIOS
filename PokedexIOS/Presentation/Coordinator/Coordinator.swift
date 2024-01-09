//
//  Coordinator.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 19/12/23.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
