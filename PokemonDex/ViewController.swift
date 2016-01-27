//
//  ViewController.swift
//  PokemonDex
//
//  Created by Sun Chung on 1/26/16.
//  Copyright © 2016 anseha. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer : AVAudioPlayer!
    var inSearchMode = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    @IBAction func musicButtonPressed(sender: UIButton) {
    
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.5
            
        } else {
            
            musicPlayer.play()
            sender.alpha = 1.0
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        // SEARCH CHANGED TO DONE IN THE KEYBOARD
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        initAudio()
        parsePokemonCSV()
    
    }
    
    func initAudio() {
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let error as NSError {
            
            print(error.debugDescription)
        
        }
        
    }
    
    func parsePokemonCSV() {
        
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            
            // CALLING THE CLASS CSV TO PARSE THE CONTENT OF POKEMON.CSV FILE
            let csv = try CSV(contentsOfURL: path)
            // PUT THEM IN ROWS AFTER PARSING
            let rows = csv.rows
            // EXTRACT EACH ROW AND SET VALUE
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                // APPEND TO THE GLOBAL VAR
                pokemon.append(poke)
                
            }
            
        } catch let error as NSError {
            
            print(error.debugDescription)
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath) as? PokemonCell {
            
            var poke : Pokemon!
            
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
            
            } else {
            
                poke = pokemon[indexPath.row]
            
            }
            
            cell.configureCell(poke)
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
        
        }
    
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    
        return 1
    
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredPokemon.count
        
        }
        
        return pokemon.count
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
        
    }
    
    // HIDES THE KEYBOARD WHEN THE SEARCH BUTTON IS CLICKED
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        view.endEditing(true)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collectionView.reloadData()
            
        } else {
            
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            // USE THE FILTER FUNCTION TO FILTER THE ARRAY
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            collectionView.reloadData()
            
        }
    
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var poke : Pokemon!
        
        if inSearchMode {
            
            poke = filteredPokemon[indexPath.row]
            
        } else {
            
            poke = pokemon[indexPath.row]
            
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
        
    }

} // END OF CLASS