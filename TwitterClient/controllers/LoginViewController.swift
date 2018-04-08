import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var txtPinCode: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
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
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        ApiService.shared.initAccessTokens()
        txtPinCode.text = ""
        txtPinCode.isEnabled = false
        btnSend.isEnabled = false
        self.btnSend.backgroundColor = UIColor(rgb: 0xD3D3D3)
    }
    
    private func performSegueAsync(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "signInSuccess", sender: nil)
        }
    }
    
    @IBAction func attemptSignIn(_ sender: UIButton) {
        ApiService.shared.requestToken(){ success in
            DispatchQueue.main.async {
                if success {
                    self.showToast("succeeded")
                    self.txtPinCode.isEnabled = true
                    self.btnSend.isEnabled = true
                    self.btnSend.backgroundColor = UIColor(rgb: 0x007AFF)
                } else {
                    self.showToast("failed")
                }
            }
        }
    }
    
    @IBAction func gainAccess(_ sender: Any) {
        ApiService.shared.getAccessToken(pinCode: txtPinCode.text!) { success in
            DispatchQueue.main.async {
                self.showToast(success ? "succeeded" : "failed")
            }
            
            if success {
                self.performSegueAsync()
            }
        }
    }
    
}
