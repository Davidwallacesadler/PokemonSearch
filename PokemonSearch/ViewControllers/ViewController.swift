//
//  ViewController.swift
//  PokemonSearch
//
//  Created by David Sadler on 9/15/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        searchBar.resignFirstResponder()
        guard let searchText = pokemonSearchBar.text else { return }
        // CHECK WHAT IS INPUT AND SEARCH BASED ON IF A NAME WAS ENTERED OR JUST A
        if searchText.isEmpty {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        } else {
            searchForPokemon(givenPokemonName: searchText) { (pokemon) in
                guard let retrievedPokemon = pokemon else {
                    DispatchQueue.main.async {
                        let noPokemonFoundAlert = UIAlertController(title: "No Pokemon Found!", message: "Please make sure you typed the pokemon's name correctly", preferredStyle: .alert)
                        noPokemonFoundAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(noPokemonFoundAlert, animated: true, completion: nil)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    return
                }
                self.selectedPokemon = retrievedPokemon
                PokemonController.getSpriteForPokemon(givenSpriteKey: retrievedPokemon.sprites.front_default, completion: { (pokemonImage) in
                    guard let image = pokemonImage else { return }
                    self.pokemonSprite = image
                    DispatchQueue.main.async {
                        self.pokemonSpriteImageView.image = image
                    }
                })
                DispatchQueue.main.async {
                    self.pokemonNameLabel.text = retrievedPokemon.name
                    self.pokemonIdentifier.text = "\(retrievedPokemon.id)"
                    self.pokemonHeightLabel.text = "\(retrievedPokemon.height)" + " Meters"
                    self.pokemonWeightLabel.text = "\(retrievedPokemon.weight)" + " Kilograms"
                    self.isOriginalPokemonLabel.text = "\(retrievedPokemon.is_default)"
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    static let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")
    
    var selectedPokemon: Pokemon?
    var pokemonSprite: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonSearchBar.delegate = self
        self.navigationItem.title = "Random Search"
    }
    
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonIdentifier: UILabel!
    @IBOutlet weak var pokemonHeightLabel: UILabel!
    @IBOutlet weak var isOriginalPokemonLabel: UILabel!
    @IBOutlet weak var pokemonWeightLabel: UILabel!
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let searchText = pokemonSearchBar.text else { return }
        // CHECK WHAT IS INPUT AND SEARCH BASED ON IF A NAME WAS ENTERED OR JUST A
        if searchText.isEmpty {
            return
        } else {
            searchForPokemon(givenPokemonName: searchText) { (pokemon) in
                guard let retrievedPokemon = pokemon else {
                    DispatchQueue.main.async {
                        let noPokemonFoundAlert = UIAlertController(title: "No Pokemon Found!", message: "Please make sure you typed the pokemon's name correctly", preferredStyle: .alert)
                        noPokemonFoundAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(noPokemonFoundAlert, animated: true, completion: nil)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                       return
                }
                self.selectedPokemon = retrievedPokemon
                PokemonController.getSpriteForPokemon(givenSpriteKey: retrievedPokemon.sprites.front_default, completion: { (pokemonImage) in
                    guard let image = pokemonImage else { return }
                    self.pokemonSprite = image
                    DispatchQueue.main.async {
                        self.pokemonSpriteImageView.image = image
                    }
                })
                DispatchQueue.main.async {
                    self.pokemonNameLabel.text = retrievedPokemon.name.capitalized
                    self.pokemonIdentifier.text = "\(retrievedPokemon.id)"
                    self.pokemonHeightLabel.text = "\(retrievedPokemon.height)" + " ft"
                    self.pokemonWeightLabel.text = "\(retrievedPokemon.weight)" + " lbs"
                    self.isOriginalPokemonLabel.text = "\(retrievedPokemon.is_default)"
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    @IBAction func getRandomOrginalPokemonButtonPressed(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        getRandomOriginalPokemon { (pokemon) in
            guard let ogPokemon = pokemon else { return }
            self.selectedPokemon = ogPokemon
            PokemonController.getSpriteForPokemon(givenId: ogPokemon.id, completion: { (image) in
                guard let pokemon = image else { return }
                DispatchQueue.main.async {
                    self.pokemonSpriteImageView.image = pokemon
                }
            })
            DispatchQueue.main.async {
                self.pokemonNameLabel.text = ogPokemon.name.capitalized
                self.pokemonIdentifier.text = "#\(ogPokemon.id)"
                self.pokemonHeightLabel.text = "\(ogPokemon.height) ft"
                self.pokemonWeightLabel.text = "\(ogPokemon.weight) lbs"
                self.isOriginalPokemonLabel.text = "\(ogPokemon.is_default)"
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
    }
    
    
    /// This function will just hit the pokemon endpoint for ditto - for practicing just getting one pokemon based on a given url.
    func getRandomOriginalPokemon(completion: @escaping (Pokemon?) -> Void) {
        let pokemonUrlString = "https://pokeapi.co/api/v2/pokemon/"
        let randomNumber = Int.random(in: 1...151)
        guard let randomPokemonUrl = URL(string: pokemonUrlString + "\(randomNumber)") else { return }
        let session = URLSession.shared
        session.dataTask(with: randomPokemonUrl) { (data, response, error) in
            print(response)
            if error != nil {
                print(error?.localizedDescription)
                completion(nil)
            }
            if let recievedData = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let pokemon = try jsonDecoder.decode(Pokemon.self, from: recievedData)
                    completion(pokemon)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)", error)
                    completion(nil)
                }
            }
            }.resume()
    }
    
    /// takes in a name of a desired pokemon and returns it if it exists
    func searchForPokemon(givenPokemonName name: String,
                          completion: @escaping (Pokemon?) -> Void) {
        // This time we need a base URL
        let lowercasedPokemon = name.lowercased()
        guard let requestUrl = URL(string: Keys.baseURL + "pokemon/\(lowercasedPokemon)") else { completion(nil); return }
        let session = URLSession.shared
        session.dataTask(with: requestUrl) { (data, response, error) in
            print(response)
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 401{
                    print("Refresh token...")
                    completion(nil)
                    return
                } else if httpResponse.statusCode == 404 {
                    print("Page not found!")
                    completion(nil)
                    return
                }
            }
            if error != nil {
                print("Error Retreiving Data:", error?.localizedDescription, error)
                completion(nil)
                return
            }
            guard let recievedData = data else {completion(nil); return }
            let decoder = JSONDecoder()
            do {
                let pokemon = try decoder.decode(Pokemon.self, from: recievedData)
                completion(pokemon)
            } catch {
                print("Error decoding JSON:", error.localizedDescription, error)
                completion(nil)
            }
        }.resume()
    }
}
