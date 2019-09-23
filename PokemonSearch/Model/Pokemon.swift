//
//  Pokemon.swift
//  PokemonSearch
//
//  Created by David Sadler on 9/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let height: Int
    let weight: Int
    let id: Int
    let is_default: Bool
    let sprites: Sprite
}

struct Sprite: Codable {
    let front_default: String
}
