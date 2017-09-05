//
//  LogoutController.swift
//  HyperTrackOnboarding
//
//  Created by Arjun Attam on 09/05/17.
//  Copyright © 2017 Hypertrack. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlacePicker
import GooglePlaces

class LogoutController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapAcceptOrderButton(_ sender: Any) {
       
    
    }
    
    func acceptOrder(orderID: String) {
        // Construct a place object for Action's expected place.
        // @NOTE: Pass either the address or the location for the expected place.
        // Both have been passed here only to show how it can be done, in case
        // the data is available.
         }
    
    @IBAction func didTapCompleteOrderButton(_ sender: Any) {
       
    }
        

    
    @IBAction func didTapLogOutButton(_ sender: Any) {

    }
    
    @IBAction func OpenMapButton(_ sender: UIButton) {
       // UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/@28.612912,77.227321,6z")!)
       
        
        
        
        let testURL = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=28.451708,77.039887&directionsmode=driving")!
        UIApplication.shared.openURL(testURL)
        
        //28.4492628090349,77.0405165479305
        //28.451708,77.0398875
        
//        if UIApplication.shared.canOpenURL(testURL) {
//            let directionsRequest = "comgooglemaps-x-callback://" +
//                "?daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York" +
//            "&x-success=sourceapp://?resume=true&x-source=AirApp"
//            
//            let directionsURL = URL(string: directionsRequest)!
//            UIApplication.shared.openURL(directionsURL)
//        } else {
//            NSLog("Can't use comgooglemaps-x-callback:// on this device.")
//        }
        
      //  self.performSegue(withIdentifier: "MapVC", sender: self)
        
    }
    
    @IBAction func ShowMyMap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "MapVC", sender: self)
        
        
        
    }
    
    @IBAction func PlacePicker(_ sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        present(placePicker, animated: true, completion: nil)

        
        
    }
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    

  
    
   }
