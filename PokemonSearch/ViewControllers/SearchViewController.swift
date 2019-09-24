//
//  SearchViewController.swift
//  PokemonSearch
//
//  Created by David Sadler on 9/23/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Deleate Methods
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
                    self.detailedPokemon = detailedPokemon
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toShowFullPokemon", sender: self)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        searchBar.resignFirstResponder()
                    }
                }
            }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fullPokemonSearchBar.delegate = self
        self.navigationItem.title = "Advanced Search"
    }
    
    // MARK: - Properties
    
    var detailedPokemon: PokemonFull?
    
    // MARK: - Outlets

    @IBOutlet weak var fullPokemonSearchBar: UISearchBar!
    
//    func generateSprites() {
//        guard let detailedPokemon = detailedPokemon else { return }
//        let sprites = [detailedPokemon.sprites.back_default, detailedPokemon.sprites.back_female, detailedPokemon.sprites.back_shiny, detailedPokemon.sprites.back_shiny_female, detailedPokemon.sprites.front_default, detailedPokemon.sprites.front_female, detailedPokemon.sprites.front_shiny, detailedPokemon.sprites.front_shiny_female]
//        var spriteImages: [UIImage] = []
//        for spriteUrl in sprites {
//            guard let url = spriteUrl else { return }
//            PokemonController.getSpriteForPokemon(givenSpriteKey: url) { (spriteImage) in
//            guard let image = spriteImage else { return }
//                spriteImages.append(image)
//            }
//        }
//        DispatchQueue.main.async {
//            self.spriteImages = spriteImages
//            self.performSegue(withIdentifier: "toShowFullPokemon", sender: self)
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }
//    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowFullPokemon" {
            guard let detailVC = segue.destination as? FullPokemonViewController, let retreivedPokemon = detailedPokemon else { return }
            detailVC.detailedPokemon = retreivedPokemon
            detailVC.navigationItem.title = retreivedPokemon.name.capitalized
        }
    }
    
    
}
