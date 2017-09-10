//
//  TaskDetailViewController.swift
//  Delivery Boy
//
//  Created by RSTI E-Services on 07/09/17.
//  Copyright © 2017 RSTI E-Services. All rights reserved.
//

import UIKit
import Alamofire

class TaskDetailViewController: UIViewController {
    @IBOutlet weak var pickupaddressText: UILabel!
    @IBOutlet weak var DeliveryAddressText: UILabel!
    @IBOutlet weak var DeliveryPersonaNameText: UILabel!
    @IBOutlet weak var DeliveryContactNumberText: UILabel!
    @IBOutlet weak var VehicleTypeText: UILabel!

    @IBOutlet weak var StartDateTimeText: UILabel!
    @IBOutlet weak var EndDateTimeText: UILabel!
    @IBOutlet weak var AdditionalInfoText: UILabel!
    public var TaskDetail = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        pickupaddressText.text = (self.TaskDetail.value(forKey: "task_pickup_address") as! String)
        DeliveryAddressText.text = (self.TaskDetail.value(forKey: "task_dropoff_address") as! String)
        DeliveryPersonaNameText.text = (self.TaskDetail.value(forKey: "task_delivery_person_name") as! String)
        DeliveryContactNumberText.text = (self.TaskDetail.value(forKey: "task_delivery_person_contact") as! String)
        VehicleTypeText.text = (self.TaskDetail.value(forKey: "task_vehicle_type") as! String)
        StartDateTimeText.text = (self.TaskDetail.value(forKey: "task_start_datetime") as! String)
        EndDateTimeText.text = (self.TaskDetail.value(forKey: "task_end_datetime") as! String)
        AdditionalInfoText.text = (self.TaskDetail.value(forKey: "task_delivery_person_address") as! String)
        
        
    }
    
    @IBAction func StartTaskButton(_ sender: UIButton) {
        
        
        
        let Driverprofile : NSDictionary  = UserDefaults.standard.value(forKey: "driverlogin") as! NSDictionary
        let DriverID : String   = Driverprofile.value(forKey: "driver_id") as! String
        let intDriverID : Int = Int(DriverID)!
        let StatusID : Int = 2
        let taskIDString: String = TaskDetail.value(forKey: "task_id") as! String
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
                    
                   self.performSegue(withIdentifier: "tripMap", sender: self)
                
                }
                    else {
                        
                        let alert = UIAlertController(title: "Fetching your assigned task", message: "Please wait", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                    
                    
                    
        }
    }
    
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            
            
            
            if segue.identifier == "tripMap" {
                if let nextViewController = segue.destination as? TripMapViewController{
                    nextViewController.OngoingTask = self.TaskDetail
                    
                    
                    
                }
                
            }
            
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
