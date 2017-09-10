//
//  TripMapViewController.swift
//  Delivery Boy
//
//  Created by RSTI E-Services on 07/09/17.
//  Copyright © 2017 RSTI E-Services. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import OpenInGoogleMaps
import SVProgressHUD
import Pulley

class TripMapViewController: UIViewController, CLLocationManagerDelegate {
    
    var OngoingTask = NSDictionary()
    var locationManager = CLLocationManager()
    var mapView = GMSMapView()
    var destinationlocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
               print("Ongoing Task is \(OngoingTask)")
        let destinationStringLat : String = OngoingTask.value(forKey: "task_dropoff_latitude") as! String
        let destinationLatitude: Double =  Double(destinationStringLat)!
        let destinationStringLong : String = OngoingTask.value(forKey: "task_dropoff_longitude") as! String
        let destinationLongitude : Double =  Double(destinationStringLong)!
        self.destinationlocation = CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude)
        
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15))
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.compassButton = true
        mapView.isTrafficEnabled = true
        mapView.backgroundColor = UIColor.lightGray
        mapView.tintColor = UIColor.blue
        mapView.mapType = .hybrid
       

        
        
        let mapInsets = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 0.0, right: 0.0)
        mapView.padding = mapInsets
        
        
        
        //so the mapView is of width 200, height 200 and its center is same as center of the self.view
        mapView.center = self.view.center
        self.view.addSubview(mapView)
        
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        // marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "My Location"
        marker.snippet = "Task 1"
        marker.map = mapView
        let markerImage = UIImage(named: "van")
        let markerImageview : UIImageView = UIImageView.init(image: markerImage)
        markerImageview.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        marker.iconView = markerImageview
        marker.position = (locationManager.location?.coordinate)!
        let DestinationMarker = GMSMarker()
        DestinationMarker.position = destinationlocation
        DestinationMarker.snippet = "Delivery Location"
        DestinationMarker.title = "Huda Metro Station"
        DestinationMarker.map = mapView
        DestinationMarker.tracksViewChanges = true
        //   DestinationMarker.icon = #imageLiteral(resourceName: "destinationMarker")
        
        let bounds = GMSCoordinateBounds()
        bounds.includingCoordinate(destinationlocation)
        bounds.includingCoordinate((locationManager.location?.coordinate)!)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        mapView.animate(with: update)
        mapView.moveCamera(update)
        mapView.settings.compassButton = true
        
        
        // let destination = "\("28.4542691"),\("77.0459559")"
        self.getPolylineRoute(from: (locationManager.location?.coordinate)!, to: destinationlocation)
        
        
        
        
        let button = UIButton.init(type: .custom)
        button.setTitle("Call", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        button.layer.cornerRadius = 40
        button.backgroundColor = UIColor(red:0.08, green:0.65, blue:1, alpha:0.7)
        button.setTitleColor(UIColor.white, for: .normal)
        button.frame = CGRect(x: 20, y: self.view.frame.height-100, width: 80, height: 80)
        button.addTarget(self, action: #selector(CallCustomerButton), for: .touchUpInside)
        button.isOpaque = true
        
        self.view.addSubview(button)
        
        let button2 = UIButton.init(type: .custom)
        button2.setTitle("Complete Trip", for: .normal)
        button2.titleLabel?.numberOfLines = 2
        button2.titleLabel?.textAlignment = .center
        button2.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        button2.layer.cornerRadius = 50
        button2.backgroundColor = UIColor(red:0.08, green:0.65, blue:1, alpha:0.7)
        button2.setTitleColor(UIColor.white, for: .normal)
        button2.frame = CGRect(x: (self.view.frame.width/2)-50, y: self.view.frame.height-105, width: 100, height: 100)
        button2.addTarget(self, action: #selector(CompleteTrip), for: .touchUpInside)
        button2.isOpaque = true
        
        self.view.addSubview(button2)
        
        let button3 = UIButton.init(type: .custom)
        button3.setTitle("Navigate", for: .normal)
        button3.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        button3.layer.cornerRadius = 40
        button3.backgroundColor = UIColor(red:0.08, green:0.65, blue:1, alpha:0.7)
        button3.setTitleColor(UIColor.white, for: .normal)
        button3.frame = CGRect(x: self.view.frame.width-100, y: self.view.frame.height-100, width: 80, height: 80)
        button3.addTarget(self, action: #selector(NavigateButton), for: .touchUpInside)
        button3.isOpaque = true
        
        self.view.addSubview(button3)
        
        
        // Do any additional setup after loading the view.
}

    func CallCustomerButton(){
        let callnumber : String = OngoingTask.value(forKey: "task_delivery_person_contact") as! String
        let alert = UIAlertController(title: callnumber, message: "Call charges may apply", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        let button2 = UIAlertAction(title: "Call", style: UIAlertActionStyle.default, handler: CallUser)
        alert.addAction(button2)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    

func CallUser(action:UIAlertAction) {
    let callnumber : String = OngoingTask.value(forKey: "task_delivery_person_contact") as! String
    callNumber(phoneNumber: callnumber)
    
    
}
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }

    
    
    func CompleteTrip(){
        
        
        
        let Driverprofile : NSDictionary  = UserDefaults.standard.value(forKey: "driverlogin") as! NSDictionary
        let DriverID : String   = Driverprofile.value(forKey: "driver_id") as! String
        let intDriverID : Int = Int(DriverID)!
        let StatusID : Int = 3
        let taskIDString: String = OngoingTask.value(forKey: "task_id") as! String
        let taskID : Int = Int(taskIDString)!
        let parameters2 = ["driver_id": intDriverID , "status": StatusID, "task_id":taskID]
        let HEADERS: HTTPHeaders = [
            "token": "d75542712c868c1690110db641ba01a",
            "Accept": "application/json",
            "Content-Type":"application/x-www-form-urlencoded",
            
            ]
        print(parameters2)
        Alamofire.request( URL(string: Trucky.baseURL + "/task/change_assigned_task_status")!, method: .post, parameters: parameters2, headers: HEADERS )
            
            
            .responseJSON { response in
                debugPrint(response)
                
                
                if let json = response.result.value {
                
                    SVProgressHUD.showSuccess(withStatus: "You have completed this task.")
                    
                    let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC")
                    
                    let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskListVC")
                    
                    let pulleyController = PulleyViewController(contentViewController: mainContentVC, drawerViewController: drawerContentVC)
                    pulleyController.initialDrawerPosition = .partiallyRevealed
                    
                    
                    
                    self.present(pulleyController, animated: true, completion: nil)

                    
                    
                   // self.dismiss(animated: true, completion: nil)
                    
                    
                  
                    
                }
                else {
                    
                    let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
                
                
                
                
        }
        
        
        
    }
    
    func NavigateButton(){
        
       // let testURL = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(destinationlocation.latitude),\(destinationlocation.longitude)&directionsmode=driving")!
//          UIApplication.shared.openURL(testURL)
        
        let testURL = URL(string: "comgooglemaps-x-truckydriverapp://?saddr=&daddr=\(destinationlocation.latitude),\(destinationlocation.longitude)&directionsmode=driving")!
        
        
     //   let testURL = URL(string: "truckydriverapp://?saddr=&daddr=\(destinationlocation.latitude),\(destinationlocation.longitude)&directionsmode=driving")!
        let mycallbackURL = URL(string: "truckydriverapp://")
        OpenInGoogleMapsController.sharedInstance().callbackURL = mycallbackURL
        var place: CLLocationCoordinate2D
        
        var definition = GoogleDirectionsDefinition()
        definition.destinationPoint = GoogleDirectionsWaypoint(location: destinationlocation)
        definition.travelMode = GoogleMapsTravelMode.driving
//        var streetViewDefinitions = GoogleStreetViewDefinition()
//        let streetviewcoordinates = CLLocationCoordinate2D.init(latitude: 25.1972018, longitude: 55.2721877)
//        streetViewDefinitions.center = streetviewcoordinates
        
     
        
        OpenInGoogleMapsController.sharedInstance().openDirections(definition)
        OpenInGoogleMapsController.sharedInstance().callbackURL = mycallbackURL
        
        
      
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
    
        mapView.padding = UIEdgeInsetsMake(0, 0, 150, 0)
        
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15)
        
        
    }
    
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        //  let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=AIzaSyAxj931MVcUeUCY4oJh-DZ7GI1_SLZtNGY")!
        var urlString = "\("https://maps.googleapis.com/maps/api/directions/json")?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&key=\("AIzaSyAxj931MVcUeUCY4oJh-DZ7GI1_SLZtNGY")"
        urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        let url2 = URL(string: urlString)
        
        
        let task = session.dataTask(with: url2!, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        let routes  = json["routes"] as? [Any]
                        if (routes?.count)! > 0 {
                            let overview_polyline : NSDictionary = routes?[0] as! NSDictionary
                            
                            
                            let polyString = overview_polyline.value(forKeyPath: "overview_polyline.points")
                            
                            
                            //Call this method to draw path on map
                            self.showPath(polyStr: polyString as! String)
                            
                        }
                        else {
                            print("No Routes Found")
                        }
                        
                    }
                    
                }catch{
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     //   mapView.camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 17)
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        
        
        
        
        
        
    }
    
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 8
        polyline.map = mapView // Your map view
        polyline.strokeColor = UIColor.blue
        
    }
    
    @IBAction func StartNavigation(_ sender: UIButton) {
        
        let testURL = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(destinationlocation.latitude),\(destinationlocation.longitude)&directionsmode=driving")!
        UIApplication.shared.openURL(testURL)
        
        
}

}


