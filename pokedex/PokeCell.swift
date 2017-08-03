//
//  PokeCell.swift
//  pokedex
//
//  Created by Atalay Aşa on 02/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    
    var pokemon:Pokemon!
    
    required init?(coder aDecoder: NSCoder) { //Her bir karenin yuvarlak corner radius kazanması için
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon:Pokemon) {
        self.pokemon = pokemon      //Pokemon modelinin view kısmı object composition yapıyoruz             OBJECT COMPOSITION YAPARKEN this önemli this = self burada olduğu gibi
        nameLbl.text = self.pokemon.name.capitalized    //oraya gelen datanın yazısını buraya aktarıyoruz.
        thumbImg.image = UIImage(named: "\(pokemon.pokedexId)") //Resimlerin IDsi 1 2 3 olduğu için burada onları veriyoruz
        
    }
    
    
    
    
}
