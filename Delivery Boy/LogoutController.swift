//
//  LogoutController.swift
//  HyperTrackOnboarding
//
//  Created by Arjun Attam on 09/05/17.
//  Copyright © 2017 Hypertrack. All rights reserved.
//

import UIKit
import HyperTrack
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
        // Check if the user is already on an order or not
        if UserDefaults.standard.string(forKey: "hypertrack_action_id") != nil {
            self.showAlert(message: "Please compelete assigned action before assigning another")
            return
        }
        
        // You can specify a lookup_id to Actions which maps to your internal id of the
        // order that is going to be tracked. This will help you search for the order on
        // HyperTrack dashboard, and get custom views for the specific order tracking.
        //
        // @NOTE: A randomly generated UUID is used as the lookup_id here. This will be the actual
        // orderID in your case which will be fetched from either your server or generated locally.
        let orderID: String = UUID().uuidString
        
        // Accept the order by creating a deliver action for the orderID
        acceptOrder(orderID: orderID)
    }
    
    func acceptOrder(orderID: String) {
        // Construct a place object for Action's expected place.
        // @NOTE: Pass either the address or the location for the expected place.
        // Both have been passed here only to show how it can be done, in case
        // the data is available.
        let expectedPlace: HyperTrackPlace = HyperTrackPlace().setAddress(address:
            "2200 Sand Hill Road, Menlo Park, CA, USA")
        
        // Create ActionParams object specifying the Delivery Type Action parameters including ExpectedPlace,
        // ExpectedAt time and Lookup_id.
        let htActionParams = HyperTrackActionParams()
        htActionParams.expectedPlace = expectedPlace
        htActionParams.type = "delivery"
        htActionParams.lookupId = orderID
        
        // Call createAndAssignAction to assign Delivery action to the current
        // user configured in the SDK using the Place object created above.
        HyperTrack.createAndAssignAction(htActionParams) { action, error in
            
            if let error = error {
                // Handle createAndAssignAction API error here
                print(error.type.rawValue)
                self.showAlert(message: error.type.rawValue)
                return
            }
            
            if let action = action {
                // Handle createAndAssignAction API success here
                print(action)
                self.showAlert(message: "You have accepted the order. Mark it complete once it is delivered!")
                
                // Save Action id and use this to query the stats of the action later.
                UserDefaults.standard.set(action.id!, forKey: "hypertrack_action_id")
            }
        }
    }
    
    @IBAction func didTapCompleteOrderButton(_ sender: Any) {
        // Get saved ActionId corresponding to the ongoing order
        let actionId = UserDefaults.standard.string(forKey: "hypertrack_action_id")
        
        // Check if the user is already on an order or not
        if actionId == nil {
            self.showAlert(message: "Please accept the order before trying to completing it.")
            return
        }
        
        // Complete Action when the order is marked complete using the saved ActionId
        HyperTrack.completeAction(actionId!)
        
        // Clear saved ActionId
        UserDefaults.standard.removeObject(forKey: "hypertrack_action_id")
        self.showAlert(message: "Order has been marked delivered!")
    }
    
    @IBAction func didTapLogOutButton(_ sender: Any) {
        // Check if the user is already on an order or not
        if UserDefaults.standard.string(forKey: "hypertrack_action_id") != nil {
            self.showAlert(message: "Please complete ongoing order before logging out.")
            return
        }
        
        // Stop tracking the user on successful logout. This indicates the user
        // is now offline.
        HyperTrack.stopTracking()
        
        // End user session by navigating to ViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        self.present(vc!, animated: true, completion: nil)
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
    

  
    
    private func showAlert(message: String) {
        // create the alert
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
