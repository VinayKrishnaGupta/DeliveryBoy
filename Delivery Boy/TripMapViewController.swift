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
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
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
        button2.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        button2.layer.cornerRadius = 50
        button2.backgroundColor = UIColor(red:0.08, green:0.65, blue:1, alpha:0.7)
        button2.setTitleColor(UIColor.white, for: .normal)
        button2.frame = CGRect(x: 120, y: self.view.frame.height-100, width: 100, height: 100)
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
        
        
    }
    
    func CompleteTrip(){
        
        
    }
    
    func NavigateButton(){
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
    
        
        
        
        
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
        mapView.camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 17)
        
        
        
        
        
        
        
        
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


