//
//  ViewController.swift
//  GottaCatchEmAll
//
//  Created by Marin Benčević on 30/06/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var resultsView: UIStackView!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    
    //MARK: - Model
    
    var pokemon: Pokemon? {
        didSet {
            
            guard let pokemon = pokemon else {
                return
            }
            
            nameLabel.text = "Name: \(pokemon.name)"
            experienceLabel.text = "Experience: \(pokemon.experience)"
            heightLabel.text = "Height: \(pokemon.height)"
            weightLabel.text = "Weight: \(pokemon.weight)"
        }
    }
    
    
    //MARK: - User interaction
    
    @IBAction func getButtonTapped(sender: UIButton) {
        
        guard let id = idTextField.text else { return }
        getPokemon(withID: id)
    }
    
    private func getPokemon(withID id: String) {
        
        //
    }
    
    
}

