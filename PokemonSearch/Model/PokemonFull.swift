//
//  PokemonFull.swift
//  PokemonSearch
//
//  Created by David Sadler on 9/22/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

// First Level Struct:

struct PokemonFull: Codable {
    let abilities: [Ability]
    let base_experience: Int
    let forms: [NameAndUrl]
    let game_indices: [GameIndex]
    let height: Int
    let held_items: [Held]
    let id: Int
    let is_default: Bool
    let location_area_encounters: String
    let moves: [Action]
    let name: String
    let order: Int
    let species: NameAndUrl
    let sprites: Sprites
    let stats: [Statistic]
    let types: [Element]
    let weight: Int
}

// Helper Structs:

struct Ability: Codable {
    let ability: NameAndUrl
    let is_hidden: Bool
    let slot: Int
}

struct NameAndUrl: Codable {
    let name: String
    let url: String
}

struct GameIndex: Codable {
    let game_index: Int
    let version: NameAndUrl
}

struct Held: Codable {
    let item: NameAndUrl
    let version_details: [VersionDetails]
}

struct VersionDetails: Codable {
    let rarity: Int
    let version: NameAndUrl
}

struct Action: Codable {
    let move: NameAndUrl
    let version_group_details: [VersionGroupDetails]
}

struct VersionGroupDetails: Codable {
    let level_learned_at: Int
    let move_learn_method: NameAndUrl
    let version_group: NameAndUrl
}

struct Sprites: Codable {
    let back_default: String
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct Statistic: Codable {
    let base_stat: Int
    let effort: Int
    let stat: NameAndUrl
}

struct Element: Codable {
    let slot: Int
    let type: NameAndUrl
}
