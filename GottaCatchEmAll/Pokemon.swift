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
    
    init?(json: AnyObject) {
        
        print(json)
        
        guard let
            id = json["id"] as? Int,
            name = json["name"] as? String,
            experience = json["base_experience"] as? Int,
            height = json["height"] as? Float,
            weight = json["weight"] as? Float
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.experience = experience
        self.height = height
        self.weight = weight
        
        let idString = String(format: "%.3d", id)
        self.imageURL = "http://assets.pokemon.com/assets/cms2/img/pokedex/detail/\(idString).png"
    }
    
}