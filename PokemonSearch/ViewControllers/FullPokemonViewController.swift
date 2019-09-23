//
//  FullPokemonViewController.swift
//  PokemonSearch
//
//  Created by David Sadler on 9/22/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class FullPokemonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - SearchBar Delegate
    
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if searchBarText.isEmpty {
            searchBar.resignFirstResponder()
            return
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            PokemonController.searchForDetailedPokemon(givenPokemonName: searchBarText) { (fullPokemon) in
                guard let detailedPokemon = fullPokemon else {
                    DispatchQueue.main.async {
                        let noPokemonFoundAlert = UIAlertController(title: "No Pokemon Found!", message: "Please make sure you typed the pokemon's name correctly or used an ID from 1 - 500", preferredStyle: .alert)
                        noPokemonFoundAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(noPokemonFoundAlert, animated: true, completion: nil)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.detailedPokemon = detailedPokemon
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.informationTableView.reloadData()
                }
                
            }
        }
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Identifier"
        case 2:
            return "Height"
        case 3:
            return "Weight"
        case 4:
            return "Forms"
        case 5:
            return "Species"
        case 6:
            return "Base Experience"
        case 7:
            return "Original Pokemon?"
        case 8:
            return "Location Area Encounters"
        case 9:
            return "Moves"
        case 10:
            return "Game Indicies"
        case 11:
            return "Abilities"
        case 12:
            return "Order"
        case 13:
            return "Held Items"
        case 14:
            return "Sprites"
        case 15:
            return "Stats"
        case 16:
            return "Types"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pokemon = detailedPokemon else { return 1 }
        switch section {
        case 9:
             // "Moves"
            return pokemon.moves.count
        case 10:
            // "Game Indicies"
            return pokemon.game_indices.count
        case 11:
            // "Abilities"
            return pokemon.abilities.count
        case 13:
            // "Held Items"
            return pokemon.held_items.count
        case 15:
            // "Stats"
            return pokemon.stats.count
        case 16:
            // "Types"
            return pokemon.types.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let basicCell = tableView.dequeueReusableCell(withIdentifier: "basicCell"), let pokemon = detailedPokemon else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            //return "Name"
            let name = pokemon.name.capitalized
            basicCell.textLabel?.text = name
            return basicCell
        case 1:
            //return "Identifier"
            basicCell.textLabel?.text = "Pokemon #\(pokemon.id)"
            return basicCell
        case 2:
            //return "Height"
            basicCell.textLabel?.text = "\(pokemon.height) ft"
            return basicCell
        case 3:
            //return "Weight"
            basicCell.textLabel?.text = "\(pokemon.weight) lbs"
            return basicCell
        case 4:
            //return "Forms"
            let form = pokemon.forms[indexPath.row]
            basicCell.textLabel?.text = form.name
            basicCell.detailTextLabel?.text = form.url
            return basicCell
        case 5:
            //return "Species"
            basicCell.textLabel?.text = pokemon.species.name
            basicCell.detailTextLabel?.text = pokemon.species.url
            return basicCell
        case 6:
            //return "Base Experience"
            basicCell.textLabel?.text = "\(pokemon.base_experience)"
            return basicCell
        case 7:
            //return "Original Pokemon?"
            if pokemon.is_default {
                basicCell.textLabel?.text = "Yes"
            } else {
                basicCell.textLabel?.text = "No"
            }
            return basicCell
        case 8:
            //return "Location Area Encounters"
            basicCell.textLabel?.text = pokemon.location_area_encounters
            return basicCell
        case 9:
            //return "Moves"
            let action = pokemon.moves[indexPath.row]
            basicCell.textLabel?.text = action.move.name
            return basicCell
        case 10:
            //return "Game Indicies"
            let gameIndex = pokemon.game_indices[indexPath.row]
            basicCell.textLabel?.text = "\(gameIndex.game_index)"
            basicCell.detailTextLabel?.text = "\(gameIndex.version.name)"
            return basicCell
        case 11:
            //return "Abilities"
            let skill = pokemon.abilities[indexPath.row]
            basicCell.textLabel?.text = skill.ability.name
            basicCell.detailTextLabel?.text = "Slot #\(skill.slot)"
            return basicCell
        case 12:
            //return "Order"
            basicCell.textLabel?.text = "Order #\(pokemon.order)"
            return basicCell
        case 13:
            //return "Held Items"
            let itemHeld = pokemon.held_items[indexPath.row]
            basicCell.textLabel?.text = "item: \(itemHeld.item.name)"
            return basicCell
        case 14:
            //return "Sprites"
            let sprites = [pokemon.sprites.back_default, pokemon.sprites.back_female, pokemon.sprites.back_shiny, pokemon.sprites.back_shiny_female, pokemon.sprites.front_default, pokemon.sprites.front_female, pokemon.sprites.front_shiny, pokemon.sprites.front_shiny_female]
            basicCell.textLabel?.text = sprites[0] // just returning the url for now -- will use a custom image cell later
            return basicCell
        case 15:
            //return "Stats"
            let statistic = pokemon.stats[indexPath.row]
            basicCell.textLabel?.text = statistic.stat.name
            basicCell.detailTextLabel?.text = "Base level: \(statistic.base_stat)"
            return basicCell
        case 16:
            //return "Types"
            let element = pokemon.types[indexPath.row]
            basicCell.textLabel?.text = element.type.name
            basicCell.detailTextLabel?.text = "Slot: \(element.slot)"
        default:
            return UITableViewCell()
        }
        return basicCell
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var informationTableView: UITableView!
    
    // MARK: - Internal Properties
    
    var detailedPokemon: PokemonFull?
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        self.informationTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Internal Methods
    
    private func setupTableView() {
        self.informationTableView.delegate = self
        self.informationTableView.dataSource = self
    }
    
    private func setupSearchBar() {
        self.searchBar.delegate = self
    }
}
