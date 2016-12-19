//
//  RestaurantsTableViewController.swift
//  RestaurantApp
//
//  Created by Camil Harchi on 13/12/2016.
//  Copyright © 2016 Camil Harchi. All rights reserved.
//


import UIKit
import MapKit

class RestaurantsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var restaurants = [Restaurant]()
    var locationManager:CLLocationManager = CLLocationManager()
    var positionUtilisateur:CLLocation?
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
  
        //geolocalisation
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        positionUtilisateur = locations[0]
        let lat = positionUtilisateur?.coordinate.latitude
        let lng = positionUtilisateur?.coordinate.longitude
        
        let url = "https://maps.googleapis.com/maps/api/place/textsearch/json?location=\(lat!),\(lng!)&radius=2000&query=restaurants&key=AIzaSyCAfNW_WkBVeUd1s6Ik9jU4VXMHwsuqNPs"
        
        telechargerRestaurants(urlString: url) { (array) in
            self.restaurants = array as! [Restaurant]
            self.tableView.reloadData()
        }
        
     
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
        let restaurant = restaurants[indexPath.row] 
        
        cell.textLabel!.text = restaurant.nom
        cell.detailTextLabel!.text = afficherNiveauPrix(prix: restaurant.niveauPrix!)
        
       
        
        return cell
    }

    
    func telechargerRestaurants(urlString:String, completion:@escaping (_ array:NSArray) -> ()) {
        
        var restaurantList = [Restaurant]()
        var openBool:Bool = false
        
        let url = URL(string: urlString)
        let session = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let liste = json["results"] as! NSArray
                
                //information restaurant
                
                for restaurant in liste {
                    
                    let resto = restaurant as! NSDictionary
                    
                    let nom = resto["name"] as! String
                    let adresse = resto["formatted_address"] as! String
                    
                    let geo = resto["geometry"] as! NSDictionary
                    let location = geo["location"] as! NSDictionary
                    let lat = location["lat"] as! Double
                    let lng = location["lng"] as! Double
                    
                    let rating = resto["rating"] as? Double ?? 0.0
                    let niveauPrix = resto["price_level"] as? Int ?? 0
                    
                    if let open = resto["opening_hours"] as? NSDictionary {
                        openBool = open["open_now"] as! Bool
                    }
                   
                    
                    let nouveauResto = Restaurant(nom: nom, latitude: lat, longitude: lng, adresse: adresse, open: openBool,  rating: Int(rating), niveauPrix: niveauPrix)
                    
                    restaurantList.append(nouveauResto)
                    
                }
                
                DispatchQueue.main.async(execute: {
                       completion(restaurantList as [Restaurant] as NSArray)
                })
       
            
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        
        session.resume()
        
        
    }
    
    
    func afficherNiveauPrix(prix: Int) -> String {
        
        var niveauPrixStr:String?
        
        switch prix {
            case 0:
                niveauPrixStr = ""
            case 1:
                niveauPrixStr = "$"
            case 2:
                niveauPrixStr = "$$"
            case 3:
                niveauPrixStr = "$$$"
            case 4:
                niveauPrixStr = "$$$$"
            default:
                niveauPrixStr = ""
        }
        
        return niveauPrixStr!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "voirDetails" {
            
            let index = tableView.indexPathForSelectedRow
            let restaurantSelected = restaurants[(index?.row)!] as Restaurant
            
            let viewVC = segue.destination as! ViewController
            viewVC.restaurant = restaurantSelected
            viewVC.positionUtilisateur = positionUtilisateur
            
        }
   
        
    }


}
