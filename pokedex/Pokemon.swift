//
//  Pokemon.swift
//  pokedex
//
//  Created by Atalay Aşa on 02/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import Foundation


class Pokemon {
    private var _name:String!
    private var _pokedexId:Int!
    private var _description:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolutionTxt:String!
    
    var name:String {
        if _name == nil {
            return ""
        }
        return _name
    }
    
    var pokedexId:Int {
        if _pokedexId == nil {
            return 0
        }
        return _pokedexId
    }
    
    var description:String {
        if _description == nil {
            return ""
        }
        return _description
    }
    
    var type:String {
        if _type == nil {
            return ""
        }
        return _type
    }
    
    var defense:String {
        if _defense == nil {
            return ""
        }
        return _defense
    }
    
    var height:String {
        if _height == nil {
            return ""
        }
        return _height
    }
    
    var weight:String {
        if _weight == nil {
            return ""
        }
        return _weight
    }
    
    var nextEvolutionTxt:String {
        if _nextEvolutionTxt == nil {
            return ""
        }
        return _nextEvolutionTxt
    }
    
    
    init(name : String , pokedexId : Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
    
    
    
}
