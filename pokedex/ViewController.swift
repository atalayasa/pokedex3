//
//  ViewController.swift
//  pokedex
//
//  Created by Atalay Aşa on 02/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import UIKit
import AVFoundation     //Audio İle uğraşıyorsan bunu kullan

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate { //2-3-4 numaralı protokoller collection view için 5 numara search button için

    @IBOutlet weak var collection:UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!      //Search bar için outlet
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()   //Arama butonu için
    var musicPlayer: AVAudioPlayer! //Müzik dodsyası
    var inSearchMode = false    //Arama butonu için
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()

    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!       //Path hep aynı şekilde
        
        do{
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string:path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1      //Müziği sonsuz döngüye sokuyor
            musicPlayer.play()
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
    

    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        //Tıklanınca pause olmasını istiyoruz
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.5  //Butonun görünürlüğünü azaltır
        }
        else {
            musicPlayer.play()
            sender.alpha = 1.0  //Görünürlüğü Geri artırır
        }
        
        
    }
    func parsePokemonCSV() {        //CSV Dosyasından okuma
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")! //CSV dosyası solda onun pathini belirttik bu tip işlemlerde try catch yapısı kullanman gerekiyor o da aşağıda
        
        do {
            
            let csv = try CSV(contentsOfURL: path)  //Parse ediyoruz burada
            let rows = csv.rows
            
            
            for row in rows {       //CSV dosyasındaki tüm satırlardaki id ve identifierları çekiyoruz
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)        //Her bir yaratılan objeyi pokemon arrayinin içine atıyoruz. Çok sayıda ismi ve IDsi olan objeyi arraya atıyoruz.
                
            }
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {   //spesifik konumda bulunan cell cell yaratacağımız yer
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell { //Ekrana aynı anda 750 item yüklemek yoracağı için resuablecell kullanırız scroll down yaptıkça yenilenir
            
           //ilk hali buydu let pokemon = Pokemon(name: "Pokemon", pokedexId: indexPath.row) //1 2 3 idli resimleri sıradan koyar indexPath.row 0. dan başlar hepsini sayar indexpath+1 koyarsan hepsi dolar yani sayaç gibi bir şey
           //ilk hali böyleydi fakat search button ekleyince onun çalışması için aşağıdaki gibi değiştiriyoruz let poke = pokemon[indexPath.row]       //Append yaptığımız yukarıdaki objeleri
            
            let poke:Pokemon!
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            
            
            
            cell.configureCell(poke)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //Item seçildiğinde ne olacağı when we tap the cell
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)   //Eğer search modundaysak filtreli arrayi değilsek tüm arrayi göndeririz. Bu perform segue fonksiyonu direk view üzerinden sayfa değişikliği değil kod üzerinden yapmamızı sağlar. Identifier ise ilk VC den detailVC ye show ekleyip identifierini PokemonDetailVC olarak tanımladık oradan geliyor. İki türlü de gönderdiğimiz array poke arrayi sender
        /////1. adım
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {   //Collection viewda kaç obje olacağı ilk 30 ddk
        //Bunu da search button ekleyince çıkarmamız gerekti çünkü arraybound of exception yiyoruz return pokemon.count
        
        if inSearchMode {
            return filteredPokemon.count
        } else {
            return pokemon.count
        }
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { //Kaç Bölümden oluşacağı
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)  //Storyboarda 105x105 boyutunda yaptığımız için
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {       //Bu da entere basıldığında klavyenin kaybolmasını sağlar
        view.endEditing(true)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {            // called when text changes (including clear)

        if searchBar.text == nil || searchBar.text == "" {
            
            
            inSearchMode = false
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1) //Search button da x e tıkladığında klavyenin kaybolması için
            collection.reloadData()
            view.endEditing(true) //Hepsini silince klavyenin kaybolmasını sağlar
    
            
            
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})     // $0 pokemon arrayindeki herhangi bir objeyi (ya da tüm objeleri) ifade eder bu array içinde key i name olanları çeker. Range of lower ise tüm o arrayin içinde arama yapar.
                collection.reloadData() //Collection viewdaki dataları yeniden yükler
            
        }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {     //ilk olarak performsegueyi tanımladık şimdi geçişi yapıyoruz 2. adım
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {      //Burada gideceğimiz detail sayfası ise casting yapıyoruz pokemondetailvc is destination
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke        //detailsVcdeki pokemon değişkeni artık bizim poke adlı pokemonlarla dolu objemiz senderları takip edersen bulursun
                }
            }
        }
    }
    
}

