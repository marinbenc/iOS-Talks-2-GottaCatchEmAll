//
//  ViewController.swift
//  GottaCatchEmAll
//
//  Created by Marin Benčević on 30/06/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import UIKit

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
    
    private var pokemon: Pokemon? {
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
        
        let pokemonResource = JSONResource(path: .Pokemon(id: id), method: .GET, parse: Pokemon.init)
        
        //get the pokemon
        Future(operation: pokemonResource.get)
            //pull out imageURL
            .map { (pokemon) -> String in
                self.pokemon = pokemon
                return pokemon.imageURL
            }
            //after you get the imageURL, get the image
            .then(getImage)
            //start the whole thing
            .start { (result) in
                switch result {
                case .Success(let data):
                    self.pokemonImageView.image = UIImage(data: data)
                
                case .Failure(let error):
                    //Note that this error can come from any future in the chain.
                    switch error {
                    case .CannotParse:
                        print("Cannot parse Pokemon!")
                    case .ValidationFailure(let error):
                        print("Validation failed: \(error)")
                    case .UnknownError(let error):
                        print("An unknown error occurred: \(error)")
                    }
                }
            }
    }
    
    private func getImage(fromURL url: String)-> Future<NSData, ServiceError> {
        return Future(operation: DataResource(url: url).get)
    }
    
    
}

