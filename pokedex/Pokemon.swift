//
//  Pokemon.swift
//  pokedex
//
//  Created by Atalay Aşa on 02/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import Foundation
import Alamofire

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
    private var _nextEvolutionName:String!
    private var _pokemonURL:String!
    private var _nextEvolutionLevel:String!
    private var _nextEvolutionId:String!
    
    
    var nextEvolutionId:String {
        if _nextEvolutionId == nil {
            return ""
        }
        return _nextEvolutionId
        
    }
    
    var nextEvolutionLevel:String {
        if _nextEvolutionLevel == nil {
            return ""
        }
        return _nextEvolutionLevel
    }
    
    
    var nextEvolutionName:String {
        if _nextEvolutionName == nil {
            return ""
        }
        return _nextEvolutionName
    }
    
    
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
    
    var attack:String {
        if _attack == nil {
            return ""
        }
        return _attack
    }
    
    
    init(name : String , pokedexId : Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)" // http://pokeapi.co/api/v1/pokemon/ linke gidecek
        
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) { //700 tane pokemon dosyasını tek tek indirmek yerine sadece tıklananı indirmek istiyoruz. Lazy loading adı veriliyor.
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in //Alamofire ile JSON tipinde istekte bulunuyoruz
            
            if let dict = response.result.value as? Dictionary<String,AnyObject> {  //Burası tüm sonuçları bir dictionarye atıyor
                
                if let weight = dict["weight"] as? String {     //Alttaki 4 tip herhangi bir arrayin içinde değil dict içindeki keyler
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {     //Bu yüzden onları Int e çeviriyoruz deneme yanılma yoluyla öğrenebiliriz tipini
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {       //attack ve defense stringe cast ettik ama aslında Integer ondan değerleri nil dönüyor
                    self._defense = "\(defense)"
                }
                print(self._weight)
                print(self._height)
                print(self._defense)
                print(self._attack)
                
                if let types = dict["types"] as? [Dictionary<String,String>] , types.count > 0 { //Arrayin içinde dictionaryler var
                    
                    if let name = types[0]["name"] {        //Arrayin 0. elemanının name keyine sahip valuesini getirir.
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {            //Eğer 1den fazla tipi varsa burada yazdırır.
                        for x in 1..<types.count {
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] , descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        let descURL = "\(URL_BASE)\(url)"       //Apiden gelen linkin başı eksik olduğu için bu değişkeni ekledik.
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in  //Dictionary içinde yeniden bir link verilmiş bu linke ulaşıp oradan descriptionu çekmemiz gerekiyor********
                          
                            if let descDict = response.result.value as? Dictionary<String,AnyObject> {
                               
                                if let description = descDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    self._description = newDescription
                                    print(newDescription)
                                    
                                }
                                
                            }
                            completed()
                        })
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>], evolutions.count > 0 {       //İlk baştaki result.value değerinden evolution arrayinin elemanını çekeceğiz
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {           //Burada bir filtreleme işlemi yapıyoruz. Rangeinde mega olanı çıkarıp mega olmayanları alıyoruz.
                            self._nextEvolutionName = nextEvo
                            
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {    //Burada yeni linke istek yapmaktansa url in içindeki idyi direk olarak çekeceğiz.
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                               
                            }
                        }
                    }
                    if let lvlExist = evolutions[0]["level"] {
                        if let lvl = lvlExist as? Int {
                            self._nextEvolutionLevel = "\(lvl)"
                        }
                    }
                    else {
                            self._nextEvolutionLevel = ""
                    }
                    
                    
                    print(self._nextEvolutionLevel)
                    print(self._nextEvolutionId)
                    
                }
            }
            
            completed()         //Eğer buraya bu komutu eklemezsek indirmenin bittiğini viewcontrollera bildiremeyiz.
            
        }
        
    }
    
}
