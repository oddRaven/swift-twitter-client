import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var txtPinCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum LocalError: Error {
        case unknown
    }
    
    @IBAction func attemptSignIn(_ sender: UIButton) {
        ApiService.shared.requestToken()
    }
    
    @IBAction func gainAccess(_ sender: Any) {
        ApiService.shared.getAccessToken(pinCode: txtPinCode.text!) { success in
            print("pin code testing was a " + (success ? "succesful" : "failure"))
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "signInSuccess", sender: nil)
                }
            }
        }
    }
    
}
