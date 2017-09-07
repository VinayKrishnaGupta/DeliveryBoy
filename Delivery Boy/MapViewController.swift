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
import Firebase
import Alamofire



class MapViewController: UIViewController, CLLocationManagerDelegate {
var locationManager = CLLocationManager()
var mapView = GMSMapView()
     var marker = GMSMarker()
 var destinationlocation : CLLocationCoordinate2D = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        
              
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
       
        let currentLatitude: Double =  (locationManager.location?.coordinate.latitude)!
        
        let currentLongitude : Double =  (locationManager.location?.coordinate.longitude)!
       
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 12))
        print("Direction is \(String(describing: locationManager.location?.speed)) \(String(describing: locationManager.location?.course))")
       
      
        
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.compassButton = true
        mapView.isTrafficEnabled = true
        mapView.backgroundColor = UIColor.gray
        mapView.tintColor = UIColor.blue
        mapView.mapType = .normal
       
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        
        let mapInsets = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 0.0, right: 0.0)
        mapView.padding = mapInsets
        
        
        
        //so the mapView is of width 200, height 200 and its center is same as center of the self.view
        mapView.center = self.view.center
        self.view.addSubview(mapView)
        
        
        
        // Creates a marker in the center of the map.
     
        let DestinationMarker = GMSMarker()
        DestinationMarker.position = destinationlocation
        let markerImage = UIImage(named: "destination")
        let markerImageview : UIImageView = UIImageView.init(image: markerImage)
        markerImageview.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        DestinationMarker.iconView = markerImageview
        
        
        DestinationMarker.snippet = "Delivery Location"
        DestinationMarker.title = "Huda Metro Station"
        DestinationMarker.map = mapView
        
        
        
        DestinationMarker.tracksViewChanges = true
     //   DestinationMarker.icon = #imageLiteral(resourceName: "destinationMarker")
        
//        let bounds = GMSCoordinateBounds()
//        bounds.includingCoordinate(destinationlocation)
//        bounds.includingCoordinate((locationManager.location?.coordinate)!)
//        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
//        mapView.animate(with: update)
//        mapView.moveCamera(update)
        mapView.settings.compassButton = true
        
       
       // let destination = "\("28.4542691"),\("77.0459559")"
        
        
        let button = UIButton.init(type: .custom)
        button.setTitle("Log out", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        button.layer.cornerRadius = 40
        button.backgroundColor = UIColor(red:0.08, green:0.65, blue:1, alpha:0.7)
        button.setTitleColor(UIColor.white, for: .normal)
        button.frame = CGRect(x: self.view.frame.width-100, y: 20, width: 80, height: 80)
        button.addTarget(self, action: #selector(customTopButton), for: .touchUpInside)
        button.isOpaque = true
    
        self.view.addSubview(button)
        
        let button2 = UIButton.init(type: .custom)
        button2.setTitle("Profile", for: .normal)
        button2.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        button2.layer.cornerRadius = 40
        button2.backgroundColor = UIColor(red:0.08, green:0.65, blue:1, alpha:0.7)
        button2.setTitleColor(UIColor.white, for: .normal)
        button2.frame = CGRect(x: 20, y: 20, width: 80, height: 80)
        button2.addTarget(self, action: #selector(customTopButton), for: .touchUpInside)
        button2.isOpaque = true
        
        self.view.addSubview(button2)
    
        
    
        // Do any additional setup after loading the view.
    }
    func customTopButton() {
        print("Top Button clicked")
    }
    
    func viewMyprofile() {
        print("Profile Button clicked")
        
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let Driverprofile : NSDictionary  = UserDefaults.standard.value(forKey: "driverlogin") as! NSDictionary
        let DriverMobilenumber : String = Driverprofile.value(forKey: "driver_contact") as! String
        print(Driverprofile)
        
        
        
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let profiledict : NSDictionary = ["name":"vinaygupta",
                                   "status":"assigned",
                                   "latitude":locationManager.location?.coordinate.latitude as Any,
                                   "logitude":locationManager.location?.coordinate.longitude as Any]
        ref.child("location").child("users").child(DriverMobilenumber).setValue(profiledict)
        
        
        
        
        let DriverID : String   = Driverprofile.value(forKey: "driver_id") as! String
        let intDriverID : Int = Int(DriverID)!
        let StatusID : Int = 1
        let parameters2 = ["driver_id": intDriverID , "status": StatusID]
        let HEADERS: HTTPHeaders = [
            "token": "d75542712c868c1690110db641ba01a",
            "Accept": "application/json",
            "Content-Type":"application/x-www-form-urlencoded",
            
            ]
        print(parameters2)
        Alamofire.request( URL(string: Trucky.baseURL + "/task/get_assignByStatus")!, method: .post, parameters: parameters2, headers: HEADERS )
            
            
            .responseJSON { response in
                debugPrint(response)
                
                
                if let json = response.result.value {
                    
                    let dict: NSDictionary = json as! NSDictionary
                    let message: String = dict.value(forKeyPath: "Response.data.message") as! String
                    let type: String = dict.value(forKeyPath: "Response.data.type") as! String
                    
                    
                    
                    if type == "success" {
                        let AssignedTasks : Array<Any> = dict.value(forKeyPath: "Response.data.assigned_task") as! Array<Any>
                        if AssignedTasks.count > 0 {
                            let OngoingTask: NSDictionary = AssignedTasks[0] as! NSDictionary
                            
                            let destinationStringLat : String = OngoingTask.value(forKey: "task_dropoff_latitude") as! String
                            let destinationLatitude: Double =  Double(destinationStringLat)!
                            let destinationStringLong : String = OngoingTask.value(forKey: "task_dropoff_longitude") as! String
                            let destinationLongitude : Double =  Double(destinationStringLong)!
                            self.destinationlocation = CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude)
                            self.getPolylineRoute(from: (self.locationManager.location?.coordinate)!, to: self.destinationlocation)
                            
                        }
                        else {
                            
                            
                    
                            }
                    }
                    else {
                        
                        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                    
                    
                    
                
                    
                }
        }
        
        
        
        

        
        
      //  self.ref.child("users").child(user.uid).setValue(["username": username])
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let Driverprofile : NSDictionary  = UserDefaults.standard.value(forKey: "driverlogin") as! NSDictionary
        let DriverMobilenumber : String = Driverprofile.value(forKey: "driver_contact") as! String
        let DriverName: String = Driverprofile.value(forKey: "driver_name") as! String
        print(Driverprofile)
        
        
        
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let profiledict : NSDictionary = ["name":DriverName,
                                          "status":"assigned",
                                          "latitude":locationManager.location?.coordinate.latitude as Any,
                                          "longitude":locationManager.location?.coordinate.longitude as Any]
        ref.child("location").child("users").child(DriverMobilenumber).setValue(profiledict)
        
        
       
        // marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        let markerImage = UIImage(named: "van")
        let markerImageview : UIImageView = UIImageView.init(image: markerImage)
        markerImageview.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        marker.iconView = markerImageview
        marker.title = "My Location"
        marker.snippet = "Task 1"
        marker.map = mapView
        marker.position = (locationManager.location?.coordinate)!
        
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
