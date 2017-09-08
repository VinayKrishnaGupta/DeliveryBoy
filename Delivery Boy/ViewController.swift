
import UIKit
import Pulley
import Alamofire


class ViewController: UIViewController {
    

    @IBOutlet weak var countryCodeField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let userdict  = (UserDefaults.standard.dictionary(forKey: "driverlogin"))
        if userdict != nil {
                    let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC")
            
                    let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskListVC")
            
                    let pulleyController = PulleyViewController(contentViewController: mainContentVC, drawerViewController: drawerContentVC)
                    pulleyController.initialDrawerPosition = .partiallyRevealed
            
                    self.present(pulleyController, animated: true, completion: nil)
            
            
            
        }
        else {
            
            
            
        }

        
        
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * This method is called when User Login button is tapped.
     * Note that this method is linked with Main.Storyboard file using this
     * button's "Touch up inside" sent event.
     *
     * @param sender
     */
    @IBAction func didTapUserLoginButton(_ sender: UIButton) {
        // Get User details, if specified
        
        let contactNumber:String = countryCodeField.text! + phoneNumberField.text!
        let currentDate : String  = getCurrentDate()
        let parameters2 = ["contact": contactNumber , "date":currentDate] as [String:String]
        
        let HEADERS: HTTPHeaders = [
            "token": "d75542712c868c1690110db641ba01a",
            "Accept": "application/json",
            "Content-Type":"application/x-www-form-urlencoded",
            
        ]
        
        Alamofire.request( URL(string: Trucky.baseURL + "/driver/login")!, method: .post, parameters: parameters2, headers: HEADERS )
            
            
            .responseJSON { response in
                debugPrint(response)
                
               
                if let json = response.result.value {
                    
                    let dict: NSDictionary = json as! NSDictionary
                    let message: String = dict.value(forKeyPath: "Response.data.message") as! String
                    let type: String = dict.value(forKeyPath: "Response.data.type") as! String
                    if type == "success" {
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
    
    /**
     * Call this method when user has successfully logged in
     */
    func onLoginSuccess() {
        self.performSegue(withIdentifier: "OTPVerifyVC", sender: self)
        
        
//        // Start tracking the user on successful login. This indicates the user
//        let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC")
//        
//        let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskListVC")
//        
//        let pulleyController = PulleyViewController(contentViewController: mainContentVC, drawerViewController: drawerContentVC)
//        
//        
//        self.present(pulleyController, animated: true, completion: nil)
        
        
        
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

    
   }
