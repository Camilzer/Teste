//
//  ViewController.swift
//  RestaurantApp
//
//  Created by Camil Harchi on 13/12/2016.
//  Copyright © 2016 Camil Harchi. All rights reserved.
//


import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var carte: MKMapView!
    var restaurant:Restaurant?
    var locationManager: CLLocationManager = CLLocationManager()
    var distanceKM:String?
    var positionUtilisateur:CLLocation?
    
    
    //infos et détails Restaurant
    @IBOutlet weak var nomRestaurantLabel: UILabel!
    @IBOutlet weak var openInfoLabel: UILabel!
    @IBOutlet weak var distanceRestaurantLabel: UILabel!
    @IBOutlet weak var ratingRestaurantLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = restaurant!.nom!
        nomRestaurantLabel.text = restaurant!.nom!
        
        ratingRestaurantLabel.text = afficherRating(rating: restaurant!.rating!)
        
        if (restaurant!.open)! {
          openInfoLabel.text = "Ouvert"
          openInfoLabel.textColor = UIColor.green
        } else {
          openInfoLabel.text = "Fermé"
          openInfoLabel.textColor = UIColor.red
        }
   
        
        carteAnnotation()
        
        //geolocalisation
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        carte.showsUserLocation = true
        
        
        //changer back button
        let backBtn = UIBarButtonItem(title: "< Retour", style: .plain, target: self, action: #selector(ViewController.retourner(sender:)))
        
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        //calculer la distance entre utilisateur et restaurant
        calculerDistance(utilisateur: positionUtilisateur!, lat: restaurant!.lat!, lng: (restaurant!.lng!)) { (distance) in
            distanceRestaurantLabel.text = distance + " km"
        }
    
    }
    
    func retourner(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func calculerDistance(utilisateur: CLLocation, lat:CLLocationDegrees, lng:CLLocationDegrees, completion:(_ distance:String)->()) {
        
        var distanceStr:String?
        var distance:CLLocationDistance?
        
        let restaurantLocation = CLLocation(latitude: lat, longitude: lng)
        distance = utilisateur.distance(from: restaurantLocation)
        
        distanceStr = String(format: "%.2f", distance! / 1000)
        
       completion(distanceStr!)
        
    }
  
    
    func afficherRating(rating:Int) -> String {
        
        var label:String?
        
        switch rating {
        
        case 0:
            label = ""
            
        case 1:
            label = "⭐"
            
        case 2:
            label = "⭐⭐"
            
        case 3:
            label = "⭐⭐⭐"
        
        case 4:
             label = "⭐⭐⭐⭐"
        
        case 5:
             label = "⭐⭐⭐⭐⭐"
            
        default:
             label = ""
        }
        
        return label!
    }
    
    func carteAnnotation() {
        
        let lat = restaurant!.lat!
        let lng = restaurant!.lng!
        
        let latDelta:CLLocationDegrees = 0.01
        let lngDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lngDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        
        carte.setRegion(region, animated: true)
        
        //annotation
        let annotation  = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = restaurant!.nom!
        annotation.subtitle = restaurant!.adresse!
        carte.addAnnotation(annotation)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

