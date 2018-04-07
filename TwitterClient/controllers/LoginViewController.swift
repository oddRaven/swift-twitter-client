import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var txtPinCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiService.shared.get(path: "1.1/account/verify_credentials.json"){ status, jsonObject in
            if(status == 200){
                self.performSegueAsync()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func performSegueAsync(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "signInSuccess", sender: nil)
        }
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
                self.performSegueAsync()
            }
        }
    }
    
}
