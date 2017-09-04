//
//  MapViewController.swift
//  Delivery Boy
//
//  Created by RSTI E-Services on 31/08/17.
//  Copyright © 2017 RSTI E-Services. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate {
var locationManager = CLLocationManager()
var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
              
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        // marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "My Location"
        marker.snippet = "+91999999999"
        marker.map = mapView
       marker.position = (locationManager.location?.coordinate)!
        
        var destinationlocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 28.612912, longitude: 77.227321)
       // let destination = "\("28.4542691"),\("77.0459559")"
        self.getPolylineRoute(from: (locationManager.location?.coordinate)!, to: destinationlocation)
        
        
    
        
        // Do any additional setup after loading the view.
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=AIzaSyAxj931MVcUeUCY4oJh-DZ7GI1_SLZtNGY")!
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
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Your map view
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
