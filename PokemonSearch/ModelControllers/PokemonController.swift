//
//  PokemonController.swift
//  PokemonSearch
//
//  Created by David Sadler on 9/19/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit

struct PokemonController {
    
    static func searchForDetailedPokemon(givenPokemonName name: String,
                                 completion: @escaping (PokemonFull?) -> Void) {
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
                let pokemon = try decoder.decode(PokemonFull.self, from: recievedData)
                completion(pokemon)
            } catch {
                print("Error decoding JSON:", error.localizedDescription, error)
                completion(nil)
            }
            }.resume()
    }
    
    
    
    static func searchForPokemon(givenPokemonName name: String,
                          completion: @escaping (Pokemon?) -> Void) {
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
    
    static func getSpriteForPokemon(givenId pokemonId: Int, completion:@escaping (_ image: UIImage?) -> Void) {
        let url = NetworkController.urlForDefaultSprite(pokemonId: pokemonId)
        
        NetworkController.performRequest(for: url, httpMethod: .get, urlParameters: nil, body: nil) { (data, error) in
            guard let error = error else {
                guard let recievedData = data else {
                    print("No data returned")
                    completion(nil)
                    return
                }
                completion(UIImage(data: recievedData as Data))
                return
            }
            print(error)
            completion(nil)
            return
        }
    }
    
    static func getSpriteForPokemon(givenSpriteKey: String, completion:@escaping (_ image: UIImage?) -> Void) {
        guard let url = URL(string: givenSpriteKey) else { return }
        
        NetworkController.performRequest(for: url, httpMethod: .get, urlParameters: nil, body: nil) { (data, error) in
            guard let error = error else {
                guard let recievedData = data else {
                    print("No data returned")
                    completion(nil)
                    return
                }
                completion(UIImage(data: recievedData as Data))
                return
            }
            print(error)
            completion(nil)
            return
        }
    }
}
