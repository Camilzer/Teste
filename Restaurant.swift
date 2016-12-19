//
//  Restaurants.swift
//  RestaurantApp
//
//  Created by Camil Harchi on 13/12/2016.
//  Copyright © 2016 Camil Harchi. All rights reserved.
//


import UIKit

class Restaurant: NSObject {
    
    var nom:String?
    var lat:Double?
    var lng:Double?
    var adresse:String?
    var open:Bool?
    var rating:Int?
    var niveauPrix:Int? //niveau entre 0 et 4 pour le plus cher
    var siteInternet:URL?
    
    init(nom:String, latitude:Double, longitude:Double, adresse:String, open:Bool, rating:Int,
         niveauPrix:Int) {
        
        self.nom = nom
        self.lat = latitude
        self.lng = longitude
        self.adresse = adresse
        self.open = false
        self.rating = rating
        self.niveauPrix = niveauPrix
    }

}
