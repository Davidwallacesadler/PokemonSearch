//
//  FullPokemonViewController.swift
//  PokemonSearch
//
//  Created by David Sadler on 9/22/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class FullPokemonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - TableView DataSource
    
     func numberOfSections(in tableView: UITableView) -> Int {
           return 16
       }
    
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
            return "Stats"
        case 15:
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
        case 14:
            // "Stats"
            return pokemon.stats.count
        case 15:
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
            basicCell.textLabel?.text = form.name.capitalized
            basicCell.detailTextLabel?.text = form.url
            return basicCell
        case 5:
            //return "Species"
            basicCell.textLabel?.text = pokemon.species.name.capitalized
            basicCell.detailTextLabel?.text = pokemon.species.url
            return basicCell
        case 6:
            //return "Base Experience"
            basicCell.textLabel?.text = "\(pokemon.base_experience) Exp"
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
            basicCell.textLabel?.text = action.move.name.capitalized
            return basicCell
        case 10:
            //return "Game Indicies"
            let gameIndex = pokemon.game_indices[indexPath.row]
            basicCell.textLabel?.text = "Index #: \(gameIndex.game_index) Version Name: \(gameIndex.version.name)"
            return basicCell
        case 11:
            //return "Abilities"
            let skill = pokemon.abilities[indexPath.row]
            basicCell.textLabel?.text = skill.ability.name + ": Slot #\(skill.slot)"
            return basicCell
        case 12:
            //return "Order"
            basicCell.textLabel?.text = "Order #\(pokemon.order)"
            return basicCell
        case 13:
            //return "Held Items"
            let itemHeld = pokemon.held_items[indexPath.row]
            basicCell.textLabel?.text = "item: \(itemHeld.item.name.capitalized)"
            return basicCell
        case 14:
            //return "Stats"
            let statistic = pokemon.stats[indexPath.row]
            basicCell.textLabel?.text = "Base level \(statistic.stat.name): \(statistic.base_stat) Exp"
            return basicCell
        case 15:
           //return "Types"
           let element = pokemon.types[indexPath.row]
           basicCell.textLabel?.text = element.type.name + " Slot: #\(element.slot)"
        default:
            return UITableViewCell()
        }
        return basicCell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 9:
                // Do network call
                
                let selectedMove = detailedPokemon!.moves[indexPath.row]
                move = selectedMove
            default:
                return
        }
    }
    
    // MARK: - Outlets

    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var informationTableView: UITableView!
    
    // MARK: - Internal Properties
    
    var detailedPokemon: PokemonFull? {
        didSet {
            getSprite()
        }
    }
    var sprite: UIImage?
    var move: Action? {
        didSet {
            self.performSegue(withIdentifier: "toShowMove", sender: self)
        }
    }
    
    func getSprite() {
        PokemonController.getSpriteForPokemon(givenSpriteKey: detailedPokemon!.sprites.front_default) { (image) in
            guard let sprite = image else { return }
            self.sprite = sprite
            DispatchQueue.main.async {
                self.spriteImageView.image = sprite
            }
            }
        }
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.informationTableView.reloadData()
        self.informationTableView.rowHeight = UITableView.automaticDimension
        self.informationTableView.estimatedRowHeight = CGFloat(100.0)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Internal Methods
    
    private func setupTableView() {
        self.informationTableView.delegate = self
        self.informationTableView.dataSource = self
        self.informationTableView.register(UINib(nibName: "SpritesTableViewCell", bundle: nil), forCellReuseIdentifier: "spritesTableViewCell")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowMove" {
            guard let detailVC = segue.destination as? MoveDetailsTableViewController, let desiredAction = move else { return }
            detailVC.navigationItem.title = desiredAction.move.name
            detailVC.selectedMove = desiredAction
        }
    }
    
}
