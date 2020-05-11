//
//  PokemonAnotacao.swift
//  PokemonGo
//
//  Created by Victor Rodrigues Novais on 10/05/20.
//  Copyright © 2020 Victoriano. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnotacao: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
    
}
