//
//  PokemonCell.swift
//  PokemonDex
//
//  Created by Sun Chung on 1/26/16.
//  Copyright © 2016 anseha. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImage : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    
    var pokemon : Pokemon!
    
    // MAKE ROUNDED CORNERS FOR THE CELL IMAGES
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
        clipsToBounds = true
        
    }
        
    func configureCell(pokemon : Pokemon) {
            
        self.pokemon = pokemon
            
        nameLabel.text = self.pokemon.name.capitalizedString
        thumbImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
            
    }

}
