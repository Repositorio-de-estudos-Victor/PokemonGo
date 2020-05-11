//
//  ViewController.swift
//  PokemonGo
//
//  Created by Victor Rodrigues Novais on 10/05/20.
//  Copyright © 2020 Victoriano. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalização = CLLocationManager()
    var contador = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configIniciaisGerenciador()
        
        // Recupera pokemons
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recuperarTodosPokemons()
        
        // Exibir Pokemons
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { (timer) in
            if let coordenadas = self.gerenciadorLocalização.location?.coordinate {
                let anotacao = MKPointAnnotation()
                
                let latAleatoria = (Double(arc4random_uniform(400)) - 250) / 100000.0
                let longAleatoria = (Double(arc4random_uniform(400)) - 250) / 100000.0
                
                anotacao.coordinate = coordenadas
                anotacao.coordinate.latitude += latAleatoria
                anotacao.coordinate.longitude += longAleatoria
                
                self.mapa.addAnnotation(anotacao)
            }
            
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            anotacaoView.image = #imageLiteral(resourceName: "player")
        }else {
            anotacaoView.image = #imageLiteral(resourceName: "pikachu-2")
        }
        
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        
        return anotacaoView
    }
    
    // Centralizar no mapa
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Executa 4x para centralizar o user
        if contador < 3 {
        
            self.centralizar()
        
            contador += 1
        }else{
            // Para a centralização
            gerenciadorLocalização.stopUpdatingLocation()
        }
    }
    
    // Autorização do usúario
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse && status != .notDetermined {
            // Alert
            
            let alertController = UIAlertController(title: "Permissão de localização", message: "Para que você possa caçar pokemons, precisamos da sua localização!", preferredStyle: .alert)
            
            // Ações do Alert
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default) { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
                
            }
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            // Setando ações no alerta
            
            alertController.addAction(acaoConfiguracoes)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
        }
        
    }

    func configIniciaisGerenciador() {
        mapa.delegate = self
        gerenciadorLocalização.delegate = self
        gerenciadorLocalização.requestWhenInUseAuthorization()
        gerenciadorLocalização.startUpdatingLocation()
    }
    
    func centralizar() {
        if let coordenadas = gerenciadorLocalização.location?.coordinate {
            let regiao = MKCoordinateRegion.init(center: coordenadas, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
        }
    }
    
    @IBAction func centralizarJogador(_ sender: Any) {
        self.centralizar()
    }
    
    @IBAction func abrirPokedex(_ sender: Any) {
    }
    
}

