
import UIKit
import Pulley
import Alamofire


class ViewController: UIViewController {
    

    @IBOutlet weak var countryCodeField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
      
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
        
        
        
        
        
        
        self.onLoginSuccess()
}
    
    /**
     * Call this method when user has successfully logged in
     */
    func onLoginSuccess() {
        
        // Start tracking the user on successful login. This indicates the user
        let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC")
        
        let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskListVC")
        
        let pulleyController = PulleyViewController(contentViewController: mainContentVC, drawerViewController: drawerContentVC)
        
        
        self.present(pulleyController, animated: true, completion: nil)
        
        
        
      //  self.performSegue(withIdentifier: "MapVC", sender: self)
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "action")
//        self.present(vc!, animated: true, completion: nil)
    }
    
   }
