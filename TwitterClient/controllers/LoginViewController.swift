import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func attemptSignIn(_ sender: UIButton) {
        guard txtUsername.text! == "username" && txtPassword.text! == "password" else{
            self.showToast("login mislukt")
            return
        }
        
        performSegue(withIdentifier: "signInSuccess", sender: nil)
    }
}