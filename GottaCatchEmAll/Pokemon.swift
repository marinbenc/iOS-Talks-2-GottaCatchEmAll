//
//  Pokemon.swift
//  GottaCatchEmAll
//
//  Created by Marin Benčević on 03/07/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation

struct Pokemon {
    
    let id: Int
    let name: String
    let experience: Int
    let height: Float
    let weight: Float
    let imageURL: String
    
    /**
     Tries to parse the JSON and create a Pokemon. If any unoptional property is not
     present in the JSON, the init will fail and return nil.
     
     - note: This is done because you don't want optional properties in your models
             (unless they really are optional). You don't want to constantly unwrap
             and handle nil values. Having non-optional and non-mutable models
             greatly reduces the complexity of your code.
    */
    init?(json: JSON) {
        
        //try to get all properties
        guard let
            id = json["id"] as? Int,
            name = json["name"] as? String,
            experience = json["base_experience"] as? Int,
            height = json["height"] as? Float,
            weight = json["weight"] as? Float
        else {
            //fail if you can't
            return nil
        }
        
        self.id = id
        self.name = name
        self.experience = experience
        self.height = height
        self.weight = weight
        
        let idString = String(format: "%.3d", id)
        
        //The pokeapi.co API doesn't provide images, so I found a site with image names
        //equal to the Pokemon's ID.
        self.imageURL = "http://assets.pokemon.com/assets/cms2/img/pokedex/detail/\(idString).png"
    }    
}
