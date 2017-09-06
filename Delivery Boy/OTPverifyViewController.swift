//
//  OTPverifyViewController.swift
//  Delivery Boy
//
//  Created by RSTI E-Services on 06/09/17.
//  Copyright © 2017 RSTI E-Services. All rights reserved.
//

import UIKit
import Alamofire
import Pulley

class OTPverifyViewController: UIViewController {
    @IBOutlet weak var otpTextField: UITextField!
  

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ContinueButton(_ sender: UIButton) {
        let OTPString : Int = Int(otpTextField.text!)!
        let currentDate : String  = getCurrentDate()
        let parameters2 = ["otp": OTPString , "date":currentDate] as [String:Any]
        
        let HEADERS: HTTPHeaders = [
            "token": "d75542712c868c1690110db641ba01a",
            "Accept": "application/json",
            "Content-Type":"application/x-www-form-urlencoded",
            
            ]
        
        Alamofire.request( URL(string: Trucky.baseURL + "/driver_login/check_otp")!, method: .post, parameters: parameters2, headers: HEADERS )
            
            
            .responseJSON { response in
                debugPrint(response)
                
                
                if let json = response.result.value {
                    
                    let dict: NSDictionary = json as! NSDictionary
                    let message: String = dict.value(forKeyPath: "Response.data.message") as! String
                    let type: String = dict.value(forKeyPath: "Response.data.type") as! String
                    
                    
                    
                    if type == "success" {
                        let Driverprofile : NSDictionary = dict.value(forKeyPath: "Response.data.session_data") as! NSDictionary
                        UserDefaults.standard.set(Driverprofile, forKey: "driverlogin")
                        UserDefaults.standard.synchronize()
                        print(Driverprofile)
                        self.onLoginSuccess()
                        
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
    
    func onLoginSuccess() {
        
        // Start tracking the user on successful login. This indicates the user
        let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC")
        
        let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskListVC")
        
        let pulleyController = PulleyViewController(contentViewController: mainContentVC, drawerViewController: drawerContentVC)
        pulleyController.initialDrawerPosition = .partiallyRevealed
        
        
        
        self.present(pulleyController, animated: true, completion: nil)
        
        
        
        //  self.performSegue(withIdentifier: "MapVC", sender: self)
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "action")
        //        self.present(vc!, animated: true, completion: nil)
    }
    
    

    
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = formatter.string(from: date)
        return currentDate
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
