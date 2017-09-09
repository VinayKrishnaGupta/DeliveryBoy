//
//  TasksViewController.swift
//  Delivery Boy
//
//  Created by RSTI E-Services on 04/09/17.
//  Copyright © 2017 RSTI E-Services. All rights reserved.
//

import UIKit
import Alamofire

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var TableView: UITableView!
    var AssignedTask  = Array<Any>()
    var SelectedTask = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        self.navigationItem.title = "My Tasks"
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        let Driverprofile : NSDictionary  = UserDefaults.standard.value(forKey: "driverlogin") as! NSDictionary
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
                        self.AssignedTask = dict.value(forKeyPath: "Response.data.assigned_task") as! Array<Any>
                        self.TableView.reloadData()
                       
                        
                    }
                    else {
                        
                        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                    
                else {
                    
                    
                }
        }
        

        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if AssignedTask.count > 0 {
            let dict: NSDictionary = AssignedTask[indexPath.row] as! NSDictionary
            let DeliveryName: String = dict.value(forKey: "task_delivery_person_name") as! String
            let DeliveryAddress : String = dict.value(forKey: "task_dropoff_address") as! String
            
            cell.textLabel?.attributedText = makeAttributedString(title: DeliveryName, subtitle: DeliveryAddress)
        }
        
       
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AssignedTask.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      print("Did select row clicked")
    self.SelectedTask = self.AssignedTask[indexPath.row] as! NSDictionary
    self.performSegue(withIdentifier: "TaskDetail", sender: self)
        
        
    }
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.justified
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline), NSForegroundColorAttributeName: UIColor.white]
        let subtitleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .subheadline),NSForegroundColorAttributeName:UIColor.white, NSParagraphStyleAttributeName:style]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        titleString.append(subtitleString)
        
        return titleString
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
        if segue.identifier == "TaskDetail" {
            let navigation = segue.destination as? UINavigationController
            if let nextViewController = navigation?.topViewController as? TaskDetailViewController{
              nextViewController.TaskDetail = self.SelectedTask
                
                
                
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
